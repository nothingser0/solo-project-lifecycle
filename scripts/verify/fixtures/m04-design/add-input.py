import io, sys
p = sys.argv[1]
s = io.open(p, encoding="utf-8").read()
s = s.replace("</main>", '<form><input type="text" placeholder="Cari produk"></form></main>')
io.open(p, "w", encoding="utf-8").write(s)
