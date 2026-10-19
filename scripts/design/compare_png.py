#!/usr/bin/env python3
"""Compare a reference design image against a rendered screenshot, region by region.

Stdlib only (zlib + struct): no Pillow, no numpy, no install step. Decodes 8-bit PNG
(gray, RGB, palette, gray+alpha, RGBA).

What it refuses to do:
  * resize either image to make them match (a width mismatch is a capture defect, not a diff)
  * report a single "fidelity percentage" (RMS distance is a locator, not a score)

Usage:
  python3 scripts/design/compare_png.py --reference design.png --candidate shot.png
  python3 scripts/design/compare_png.py --reference a.png --candidate b.png --region hero:0,0,1024,600
  python3 scripts/design/compare_png.py --reference a.png --candidate b.png --json

Exit codes:
  0  compared (differences may exist; read the report)
  2  could not compare (size mismatch, unsupported format, bad region)
"""
import argparse
import json
import math
import struct
import sys
import zlib
from pathlib import Path

PNG_SIG = b"\x89PNG\r\n\x1a\n"


def _paeth(a, b, c):
    p = a + b - c
    pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
    if pa <= pb and pa <= pc:
        return a
    return b if pb <= pc else c


def decode_png(path):
    """Return (width, height, channels, bytearray of raw samples). Raises ValueError."""
    data = Path(path).read_bytes()
    if not data.startswith(PNG_SIG):
        raise ValueError(f"{path}: not a PNG (signature mismatch)")

    pos, idat, ihdr, palette = 8, [], None, None
    while pos < len(data):
        if pos + 8 > len(data):
            raise ValueError(f"{path}: truncated chunk header")
        (length,) = struct.unpack(">I", data[pos:pos + 4])
        ctype = data[pos + 4:pos + 8]
        body = data[pos + 8:pos + 8 + length]
        if len(body) != length:
            raise ValueError(f"{path}: truncated {ctype!r} chunk")
        if ctype == b"IHDR":
            ihdr = struct.unpack(">IIBBBBB", body)
        elif ctype == b"PLTE":
            palette = body
        elif ctype == b"IDAT":
            idat.append(body)
        elif ctype == b"IEND":
            break
        pos += 12 + length

    if ihdr is None:
        raise ValueError(f"{path}: no IHDR")
    width, height, depth, color_type, _, _, interlace = ihdr
    if depth != 8:
        raise ValueError(f"{path}: {depth}-bit PNG unsupported (8-bit only)")
    if interlace:
        raise ValueError(f"{path}: interlaced PNG unsupported")

    channels = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}.get(color_type)
    if channels is None:
        raise ValueError(f"{path}: colour type {color_type} unsupported")
    if color_type == 3 and palette is None:
        raise ValueError(f"{path}: palette image with no PLTE")

    try:
        raw = zlib.decompress(b"".join(idat))
    except zlib.error as exc:
        raise ValueError(f"{path}: corrupt IDAT ({exc})") from exc

    stride = width * channels
    expected = (stride + 1) * height
    if len(raw) < expected:
        raise ValueError(f"{path}: image data short ({len(raw)} < {expected})")

    out = bytearray(stride * height)
    prev = bytearray(stride)
    src = 0
    for y in range(height):
        ftype = raw[src]
        src += 1
        line = bytearray(raw[src:src + stride])
        src += stride
        if ftype == 1:
            for i in range(channels, stride):
                line[i] = (line[i] + line[i - channels]) & 0xFF
        elif ftype == 2:
            for i in range(stride):
                line[i] = (line[i] + prev[i]) & 0xFF
        elif ftype == 3:
            for i in range(stride):
                left = line[i - channels] if i >= channels else 0
                line[i] = (line[i] + ((left + prev[i]) >> 1)) & 0xFF
        elif ftype == 4:
            for i in range(stride):
                left = line[i - channels] if i >= channels else 0
                upleft = prev[i - channels] if i >= channels else 0
                line[i] = (line[i] + _paeth(left, prev[i], upleft)) & 0xFF
        elif ftype != 0:
            raise ValueError(f"{path}: unknown filter type {ftype} on row {y}")
        out[y * stride:(y + 1) * stride] = line
        prev = line

    if color_type == 3:
        expanded = bytearray(width * height * 3)
        for i, idx in enumerate(out):
            base = idx * 3
            if base + 2 >= len(palette):
                raise ValueError(f"{path}: palette index {idx} out of range")
            expanded[i * 3:i * 3 + 3] = palette[base:base + 3]
        return width, height, 3, expanded

    return width, height, channels, out


def rms_region(ref, cand, box):
    """Root mean square of the per-channel differences (0 for identical images)."""
    x, y, w, h = box
    rw, rc, rb = ref
    cw, cc, cb = cand
    total = 0.0
    count = 0
    for row in range(y, y + h):
        rs = (row * rw + x) * rc
        cs = (row * cw + x) * cc
        n = w * rc
        for i in range(n):
            delta = rb[rs + i] - cb[cs + i]
            total += delta * delta
        count += n
    return math.sqrt(total / count) if count else 0.0


def diff_region(ref, cand, box):
    """Mean absolute difference per channel, 0-255."""
    x, y, w, h = box
    rw, rc, rb = ref
    cw, cc, cb = cand
    if rc != cc:
        raise ValueError(f"channel count differs ({rc} vs {cc}); compare images of the same type")
    total = 0
    count = 0
    for row in range(y, y + h):
        rs = (row * rw + x) * rc
        cs = (row * cw + x) * cc
        n = w * rc
        for i in range(n):
            total += abs(rb[rs + i] - cb[cs + i])
        count += n
    return total / count if count else 0.0


def parse_region(text):
    name, numbers = text.split(":", 1)
    parts = [int(v) for v in numbers.split(",")]
    if len(parts) != 4:
        raise ValueError(f"region {name!r}: expected name:x,y,w,h")
    return name, tuple(parts)


def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--reference", required=True, help="design image (the baseline)")
    ap.add_argument("--candidate", required=True, help="rendered screenshot")
    ap.add_argument("--region", action="append", default=[],
                    help="name:x,y,w,h in reference pixels; repeatable")
    ap.add_argument("--allow-height-difference", action="store_true",
                    help="long-page diagnosis: compare only the shared area and report the tail")
    ap.add_argument("--json", action="store_true", help="machine-readable output")
    args = ap.parse_args()

    try:
        rw, rh, rc, rb = decode_png(args.reference)
        cw, ch, cc, cb = decode_png(args.candidate)
    except (ValueError, OSError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    if rw != cw:
        print(f"error: width mismatch — reference {rw}px, candidate {cw}px. "
              "Fix the viewport, DPR or capture scale. This tool will not rescale.",
              file=sys.stderr)
        return 2
    if rh != ch and not args.allow_height_difference:
        print(f"error: height mismatch — reference {rh}px, candidate {ch}px. "
              "Use --allow-height-difference for a long-page diagnosis (compares the shared area only).",
              file=sys.stderr)
        return 2

    compare_h = min(rh, ch)
    ref, cand = (rw, rc, rb), (cw, cc, cb)

    regions = []
    for raw in args.region:
        try:
            name, (x, y, w, h) = parse_region(raw)
        except ValueError as exc:
            print(f"error: {exc}", file=sys.stderr)
            return 2
        if min(x, y) < 0 or min(w, h) <= 0 or x + w > rw or y + h > compare_h:
            print(f"error: region {name!r} out of bounds for {rw}x{compare_h}", file=sys.stderr)
            return 2
        regions.append({"name": name, "box": [x, y, w, h],
                        "mad": round(diff_region(ref, cand, (x, y, w, h)), 2),
                        "rms": round(rms_region(ref, cand, (x, y, w, h)), 2)})

    whole = {"mad": round(diff_region(ref, cand, (0, 0, rw, compare_h)), 2),
             "rms": round(rms_region(ref, cand, (0, 0, rw, compare_h)), 2)}

    report = {
        "reference": {"path": str(args.reference), "width": rw, "height": rh},
        "candidate": {"path": str(args.candidate), "width": cw, "height": ch},
        "compared_height": compare_h,
        "height_delta": ch - rh,
        "whole_image": whole,
        "regions": regions,
    }

    if args.json:
        print(json.dumps(report, indent=2))
    else:
        print(f"reference {rw}x{rh}  candidate {cw}x{ch}")
        if ch != rh:
            print(f"  height delta {ch - rh:+d}px (compared the first {compare_h}px)")
        print(f"  whole image: mean abs diff {whole['mad']:.2f}/255, RMS {whole['rms']:.2f}")
        if regions:
            print()
            print(f"  {'region':<24} {'box':<22} {'MAD':>7} {'RMS':>7}")
            for item in sorted(regions, key=lambda r: -r["mad"]):
                box = ",".join(str(v) for v in item["box"])
                print(f"  {item['name']:<24} {box:<22} {item['mad']:>7.2f} {item['rms']:>7.2f}")
        print()
        print("A difference locates the problem. It is not a fidelity score:")
        print("photography, substituted fonts and missing brand masters all move the number.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
