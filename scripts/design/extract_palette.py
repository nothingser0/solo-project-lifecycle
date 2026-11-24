#!/usr/bin/env python3
"""
Extract pixel-precise design tokens directly from inspiration screenshots.
Uses Pillow to sample exact canvas background, card surfaces, dominant accent, and neutrals.
Eliminates LLM color hallucination.

Usage:
  python3 scripts/design/extract_palette.py docs/design/inspiration/ref-01-estify-dashboard.jpg
  python3 scripts/design/extract_palette.py <image_path> --json
"""

import sys
import json
import argparse
from pathlib import Path
from collections import Counter
import colorsys

def rgb_to_hex(r, g, b):
    return f"#{r:02X}{g:02X}{b:02X}"

def extract_palette(image_path):
    try:
        from PIL import Image
    except ImportError:
        print("Error: Pillow is required. Run 'pip install Pillow' first.", file=sys.stderr)
        sys.exit(1)

    path = Path(image_path)
    if not path.exists():
        print(f"Error: File not found: {path}", file=sys.stderr)
        sys.exit(1)

    img = Image.open(path).convert("RGB")
    w, h = img.size

    # 1. Downsample for full-image color clustering
    thumb_w = 200
    thumb_h = max(1, int(200 * h / w))
    small = img.resize((thumb_w, thumb_h))
    
    # Use modern Pillow getdata / flattened
    try:
        pixels = list(small.getdata())
    except Exception:
        pixels = [small.getpixel((x, y)) for y in range(thumb_h) for x in range(thumb_w)]

    # 2. Detect Canvas & Surface
    # Cards are usually pure #FFFFFF, canvas is the soft off-white/light-gray behind them
    pure_white = []
    canvas_candidates = []
    dark_neutrals = []
    saturated_accents = []

    for r, g, b in pixels:
        h_val, s_val, v_val = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)
        # Saturated color (brand accents)
        if s_val >= 0.35 and v_val >= 0.30:
            saturated_accents.append((r, g, b, h_val))
        elif v_val >= 0.98 and s_val <= 0.05:
            pure_white.append((r, g, b))
        elif 0.88 <= v_val < 0.98 and s_val <= 0.12:
            canvas_candidates.append((r, g, b))
        elif v_val <= 0.25 and s_val < 0.25:
            dark_neutrals.append((r, g, b))

    # Canvas Hex
    canvas_hex = "#F7F8FA"
    if canvas_candidates:
        rounded_canvas = [rgb_to_hex(*c) for c in canvas_candidates]
        canvas_hex = Counter(rounded_canvas).most_common(1)[0][0]

    # Surface hex (cards)
    surface_hex = "#FFFFFF"
    if pure_white and len(pure_white) > 50:
        surface_hex = "#FFFFFF"
    elif canvas_candidates:
        surface_hex = canvas_hex

    # Dark text hex
    text_hex = "#1E293B"
    if dark_neutrals:
        rounded_dark = [rgb_to_hex(*c) for c in dark_neutrals]
        text_hex = Counter(rounded_dark).most_common(1)[0][0]

    # Primary & Secondary Accents
    primary_accent = "#FF9432"
    secondary_accent = "#3B82F6"
    if saturated_accents:
        # Cluster accents by hue (bucket 0-360 in 12 bins)
        hue_bins = {}
        for r, g, b, h_val in saturated_accents:
            bin_idx = int(h_val * 12)
            if bin_idx not in hue_bins:
                hue_bins[bin_idx] = []
            hue_bins[bin_idx].append((r, g, b))

        sorted_bins = sorted(hue_bins.items(), key=lambda item: len(item[1]), reverse=True)
        if sorted_bins:
            top_bin_colors = sorted_bins[0][1]
            # pick median/most common in top bin
            top_hexes = [rgb_to_hex(*c) for c in top_bin_colors]
            primary_accent = Counter(top_hexes).most_common(1)[0][0]

        if len(sorted_bins) > 1:
            second_bin_colors = sorted_bins[1][1]
            second_hexes = [rgb_to_hex(*c) for c in second_bin_colors]
            secondary_accent = Counter(second_hexes).most_common(1)[0][0]

    return {
        "image": str(path.name),
        "dimensions": f"{w}x{h}",
        "canvas_background": canvas_hex,
        "card_surface": surface_hex,
        "primary_accent": primary_accent,
        "secondary_accent": secondary_accent,
        "text_primary": text_hex
    }

def main():
    parser = argparse.ArgumentParser(description="Extract verified color tokens from design screenshot")
    parser.add_argument("image", help="Path to reference screenshot (JPG/PNG)")
    parser.add_argument("--json", action="store_true", help="Output raw JSON")
    args = parser.parse_args()

    palette = extract_palette(args.image)

    if args.json:
        print(json.dumps(palette, indent=2))
        return

    print("=" * 65)
    print(f"PIXEL-SAMPLED DESIGN TOKENS ({palette['image']} - {palette['dimensions']})")
    print("=" * 65)
    print(f"Canvas Background  : {palette['canvas_background']} (Viewport base surface)")
    print(f"Card Surface       : {palette['card_surface']} (Elevated container)")
    print(f"Primary Accent     : {palette['primary_accent']} (Brand CTA & active highlights)")
    print(f"Secondary Accent   : {palette['secondary_accent']} (Gauges / secondary badge)")
    print(f"Primary Text       : {palette['text_primary']} (Headings & body)")
    print("-" * 65)
    print("Copy directly into docs/design/inspiration/notes.md & docs/harness-root/DESIGN.md:")
    print(f"  --background: {palette['canvas_background']};")
    print(f"  --card: {palette['card_surface']};")
    print(f"  --primary: {palette['primary_accent']};")
    print(f"  --foreground: {palette['text_primary']};")
    print("=" * 65)

if __name__ == "__main__":
    main()
