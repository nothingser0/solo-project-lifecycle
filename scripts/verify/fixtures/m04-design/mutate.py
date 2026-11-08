#!/usr/bin/env python3
"""Introduce one browser-visible defect into the M04 fixture.

kind: svg-text | svg-tiny | spec-leak | sitemap | stray-color | no-charset | no-alt | hollow |
      page-style
"""
import io
import os
import re
import sys

root, kind = sys.argv[1], sys.argv[2]

logo = os.path.join(root, "docs/design/brand/logo.svg")
screen1 = os.path.join(root, "docs/design/screens/scr-01.html")
sitemap = os.path.join(root, "docs/specs/SITEMAP.md")
css = os.path.join(root, "docs/design/screens/style.css")


def read(p):
    return io.open(p, encoding="utf-8").read()


def write(p, s):
    io.open(p, "w", encoding="utf-8").write(s)


if kind == "svg-text":
    write(logo, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">'
                '<rect width="64" height="64" fill="#1d4ed8"/>'
                '<text x="32" y="40" font-size="20" fill="#ffffff">KC</text></svg>\n')

elif kind == "svg-tiny":
    write(logo, '<svg xmlns="http://www.w3.org/2000/svg"/>\n')

elif kind == "spec-leak":
    s = read(screen1)
    s = s.replace("<h1>Kasir Cepat</h1>", "<h1>Kasir Cepat SCR-01</h1>")
    write(screen1, s)

elif kind == "sitemap":
    s = read(sitemap)
    s += "\n| SCR-17 | /reports | Reports | F-01 | 1. Chart |\n"
    write(sitemap, s)

elif kind == "stray-color":
    s = read(css)
    s += "\n.cta { background: #ff00aa; color: #111111; }\n"
    write(css, s)

elif kind == "no-charset":
    s = read(screen1)
    s = re.sub(r'(?m)^\s*<meta charset[^>]*>\n', '', s)
    write(screen1, s)

elif kind == "no-alt":
    s = read(screen1)
    s = s.replace("</main>", '<img src="../brand/logo.svg"></main>')
    write(screen1, s)

elif kind == "hollow":
    write(screen1, '<!DOCTYPE html><html lang="id"><head><meta charset="utf-8">'
                   '<meta name="viewport" content="width=device-width">'
                   '<title>Kosong</title><link rel="stylesheet" href="style.css"></head>'
                   '<body><main><p>segera hadir</p></main></body></html>\n')

elif kind == "page-style":
    s = read(screen1)
    s = s.replace("</head>", "<style>.x { color: red; }</style></head>")
    write(screen1, s)

else:
    raise SystemExit(f"unknown kind {kind}")

print(kind)
