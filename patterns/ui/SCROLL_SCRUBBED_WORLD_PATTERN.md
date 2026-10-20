# Scroll-Scrubbed Cinematic World Pattern

> **Module**: M04 (UI/UX Landing Page) & M06 (Frontend Engineering)
> **Source**: Adapted from a published scroll-world engine (MIT) — seam law, camera architectures, mobile hardening, and the blob-seek engine — plus Apple-style scroll-through landing pages.
> **Objective**: A hero where **scroll drives a camera**: a pre-rendered flight through scenes, scrubbed by scroll position, with no visible cuts and no framework lock-in.

---

## 1. The Physics

The video never autoplays. Its `currentTime` is bound to scroll progress:

```
video.currentTime = clamp(scrollProgress, 0, 1) * video.duration
```

Scroll down → the camera flies forward. Scroll **up** → it plays in reverse, for free. That reversibility is a constraint, not a bonus: any seam that stutters forward also stutters backward.

**Consequence for design**: a scroll-scrub hero is a *film*, not a page. You are writing shot list, not layout.

---

## 2. The Two Failure Modes (fix these first)

Most scroll-cinematics fail for exactly two reasons. Everything else is polish.

### 2.1 Frozen video — `seekable = [0,0]`

**Symptom**: the video shows frame 0 forever, no matter how far you scroll.

**Cause**: many static hosts (including `python -m http.server`) do not serve HTTP **byte-range** requests. Without ranges, the browser cannot seek, so `video.seekable` collapses to `[0,0]` and every `currentTime` assignment clamps to zero.

**Fix**: fetch each clip as a `Blob` and play it from an in-memory object URL. Blobs are always fully seekable.

```js
fetch(url)
  .then(r => r.ok ? r.blob() : Promise.reject(new Error('404')))
  .then(blob => { video.src = URL.createObjectURL(blob); });
```

**This is the root cause.** The commonly-prescribed "use all-intra encoding" treats a symptom: with a working blob URL you do **not** need all-intra, and all-intra bloats an 8-second clip from ~8 MB to ~25 MB. Verify the fix with `video.seekable.end(0) > 0`.

### 2.2 Seam pop — mismatched handoff frames

**Symptom**: a visible jump when the film moves from one clip to the next.

**Cause**: the connector was built from the *original still*, not from the neighbouring clips' *actual rendered frames*. Every generation renders slightly differently, so two renders of "the same scene" do not match.

**Fix — the seam law** (§4).

---

## 3. Camera Architecture: A or B

How the camera moves *between* scenes is the biggest quality lever. Pick one per project; never mix.

### A — Continuous forward take (default for grounded / realistic / walkthrough)

One camera that only ever glides **forward**, scene 1 to scene N, as a single take.

- Leg 0 starts from scene 0's still.
- Each later leg's `start-image` = the **previous leg's actual last frame** (extract with ffmpeg).
- **No `end-image`** — an end-image of a wide establishing shot forces the camera to pull back, which is the #1 cause of stutter.
- There are **no connectors**: the legs *are* the journey.

Cost: strictly sequential (cannot parallelise) and slower.

### B — Dive-in + aerial connector (only for diorama / miniature / god's-eye worlds)

A "dive into each scene" clip, plus a connector that pulls **up and out** and flies to the next scene.

- The pull-out **reverses camera direction at every seam** (forward dive → backward pull-out).
- In a miniature world that reads as an intentional "zoom out to the map, fly to the next island". In a grounded first-person walkthrough it reads as a **rewind**.

Use B only for the map-like aesthetic. If a client picks B against a photoreal direction, say why it will read as a stutter and confirm before rendering.

### The seam rule is not the leg rule

"Forward only" governs **seams**, not individual shots. Inside a single leg there is no seam, so the camera is free: orbits, crane-ups, lateral tracks, push-in-and-ease-back are all safe. What must hold is:

- **Position continuity** — next leg starts from the previous leg's *actual* last frame.
- **Velocity continuity** — the camera must never reverse *across* a seam.

Give each leg a **motion handoff contract**: every leg *ends* settling into a slow steady forward drift (final ~1 s), and every leg *begins* continuing that same drift. Keep both clauses verbatim in the prompt. The expressive move lives in the middle.

| Concept | Mid-leg move |
| :--- | :--- |
| Product / luxury retail | slow half-orbit around the hero object, then continue past |
| Real estate / hospitality | steadicam glide through doorways; gentle crane-up in atria |
| Industrial / process | low lateral track alongside the line, foreground parallax |
| Travel / outdoors | drone-style rise-and-reveal, then descending swoop |
| Food / craft | push in close to the craft moment, ease back, carry on |

Expressive moves raise re-roll odds: **eyeball each leg's last frame before chaining the next**. If it doesn't look like a frame from a calm forward glide, re-roll — a bad handoff frame poisons every leg after it.

### Locked-isometric variant

Architecture A with every leg pinned to one angle: *"the camera keeps exactly the same high isometric angle throughout — no rotation, no orbit, no tilt; it only travels straight and level."* Calmest look, cheapest re-rolls. Watch for angle drift on long legs and re-roll if the view has rotated.

---

## 4. The Seam Law

For architecture B, a connector flies from the end of scene *i* into the start of scene *i+1*. **Both endpoints must be the actual rendered frames of the neighbouring clips — never the original still.**

```
connector.start = last frame extracted from dive_i's rendered video
connector.end   = first frame extracted from dive_{i+1}'s rendered video
```

```bash
ffmpeg -sseof -0.15 -i dive_i.mp4      -frames:v 1 -q:v 2 dive_i_last.png
ffmpeg -ss 0       -i dive_next.mp4    -frames:v 1 -q:v 2 dive_next_first.png
```

Now every seam is frame-identical on both sides: `dive_i.end == connector.start` and `connector.end == dive_next.start`.

**Insurance**: video models land *close* to the end-image but not always pixel-perfect. Keep a short **crossfade** (a few frames) at each seam. Frame-matched endpoints + a small crossfade = no visible cut. Never rely on the crossfade alone — a content jump cannot be hidden by a dissolve.

---

## 5. Encoding: Native Resolution, Small GOP

Scrubbing cost is dominated by **frames-from-keyframe**. Two rules:

1. **Do not downscale to make seeking smooth.** Encode at native resolution (1080p), `crf ~20`, add a light `unsharp` to counter video softness.
2. **Small GOP, not all-intra.** `-g 8` (mobile `-g 4`) is the sweet spot: all-intra bloats an 8 s clip to ~25 MB; GOP 8 is ~8 MB and scrubs fine once the clip is a blob.

```bash
ffmpeg -i src.mp4 -an -vf "unsharp=5:5:0.8:5:5:0.0" \
  -c:v libx264 -preset slow -crf 20 -pix_fmt yuv420p \
  -g 8 -keyint_min 8 -sc_threshold 0 -movflags +faststart out.mp4
```

Mobile encodes: `scale=-2:720`, `-g 4`, `crf 23` — a 720p file with twice the keyframe density scrubs far smoother on a phone decoder.

Strip audio, add `+faststart`, and keep the stills — they double as posters and lazy-load fallbacks.

---

## 6. Mobile

Two different things, often conflated:

**(a) Not breaking on a phone** — always on, not optional:
- **Seek coalescing**: never issue a new `currentTime` while the decoder is still `seeking`. Without this, a fast flick queues seeks and freezes the clip.
- **iOS priming**: a muted video that was never played will not paint a seeked frame. Prime each video with a muted `play() → pause()` on first user gesture.
- **Poster until paint**: keep the still visible until the clip's first `seeked` event, or iOS flashes an empty scene.
- **Ignore height-only resizes**: the URL bar sliding in/out fires `resize`; re-laying out there yanks the scroll position. Gate on width change, keep `orientationchange`.
- **Safe-area insets**: `env(safe-area-inset-bottom)` + `dvh`, and `<meta viewport content="…,viewport-fit=cover">`.

**(b) A real mobile version** — opt-in, ~2× render cost:
- Render a **native 9:16 portrait chain**, not a crop of the landscape film.
- Wire `clipMobile` / `connectorsMobile` / `stillMobile` per section.
- **Never ship a centre-crop as "the mobile version" silently.** If credits can't cover the portrait chain, say so and offer crop encodes as an explicitly-labelled stopgap the user must approve.

---

## 7. Configuration Shape

The engine is config-driven and framework-agnostic (it builds its own DOM and injects namespaced CSS):

```js
mountScrollWorld(document.getElementById('world'), {
  brand: { name: 'Pearl & Co.' },
  diveScroll: 1.3, connScroll: 0.9,        // viewport-heights of scroll per clip
  sections: [
    { id:'farm', label:'The Farms', still:'assets/farm.webp', clip:'assets/vid/farm.mp4',
      scroll: 1.6,                          // per-section override: more scroll = longer dwell
      linger: 0.45,                         // 0–1: camera settles mid-scene while copy peaks
      accent:'#8FB98A', eyebrow:'From leaf to last sip',
      title:'It starts in the hills.', body:'…', tags:['Single-origin','Hand-picked'] },
    // …last section may carry a `cta`
  ],
  connectors: ['assets/vid/conn1.mp4'],     // length = sections - 1
});
```

**Pacing**: `scroll` overrides `diveScroll` for one scene; `linger` (keep ≤ 0.6) remaps time so the camera settles mid-scene — exactly while the copy peaks — then speeds up toward the seam. Seam frames are untouched (`f(0)=0, f(1)=1`). Give the hero and finale a higher `scroll` + some `linger`; keep transit scenes brisk.

**Reduced motion**: never load the clips at all. Stills stay up and cross-dissolve. No decode cost, no motion.

**Theme**: the visual identity comes from the generated clips, so the chrome stays quiet — a handful of CSS variables (`--sw-bg`, `--sw-ink`, `--sw-accent`) is enough.

**Asset**: `templates/ui/scroll-scrub-engine.js` — the portable engine (blob-seek, lazy load, seam crossfade, copy pinning, route rail, reduced-motion, phone hardening). `templates/ui/scroll-world-index.html` is a minimal standalone page that mounts it.

---

## 8. Production Discipline

### 8.1 Never trust a model's documented capability

Only models that accept **both** `start-image` and `end-image` can make connectors. A model with reference-only inputs can *condition* a generation but cannot *continue* a shot — it physically cannot hold a seam. Verify with the provider's schema inspection before batching, and decline a user-requested model that cannot frame-lock rather than silently substituting.

### 8.2 One model for the whole chain

Each renderer has its own motion, colour, and grain character. Mixing models mid-chain keeps *position* continuity but the render-character shift reads as a subtle pop. The one sanctioned exception is a content-filter fallback for a single stubborn clip.

### 8.3 Qualify before you spend

For any new endpoint or model, run **two cheap probes** before committing a full build:
1. **Leg probe** — prompt + first frame: output frame 0 must match the input to codec noise (PSNR ≳ 30 dB).
2. **Connector probe** — add a last frame from a different still: the end must land on that composition.

A near-miss end frame is acceptable (the crossfade covers it). An unrelated output is a disqualification.

### 8.4 State the cost before rendering

`N stills + (2N−1) clips [×2 if mobile] + ~15% re-roll headroom`. Calibrate from **one** real still and **one** real clip, then extrapolate — never guess a per-clip price. Warn when the estimate exceeds ~70% of the available balance, and get a go before generating.

### 8.5 PSNR is not the seam test

Judge seams by **composition**, not raw PSNR. A correctly frame-locked seam at 720p/1080p can read ~18–25 dB from detail shimmer alone. A real mismatch shows as different composition or props — not softness.

### 8.6 Content filters are a schedule risk

Video content filters produce false positives on innocuous interiors (bedroom, pool, spa, "bed", "waterfall", "wine"). Budget re-rolls on interior-heavy projects, and have a documented fallback chain: re-roll → strip trigger words → different provider for that one clip → drop the connector slot (the engine crossfades that seam directly).

---

## 9. Failure Modes

| Symptom | Cause | Fix |
| :--- | :--- | :--- |
| Frozen at frame 0 | `seekable=[0,0]`, host lacks byte ranges | Blob URL (§2.1) |
| Huge files | All-intra encoding | `-g 8` + blob |
| Seam pop | Connector endpoints were stills | Actual rendered frames (§4) |
| Seam "rewinds" | Velocity reverses (dive → pull-out) | Architecture A, or accept B only for miniature |
| Stutter on fast flick (phone) | Seeks queue up | Coalesce seeks + `-g 4` mobile encode |
| Blank scene on iOS | Video never played, so never painted | Prime on first gesture + keep poster until `seeked` |
| Page jumps while scrolling (phone) | URL-bar resize triggers relayout | Ignore height-only resizes |
| Soft / low quality | Downscaled or over-compressed | Native res, crf ≤ 20, `unsharp` |
| Portrait crop cuts the subject | 16:9 clip on a tall phone | Native 9:16 chain, never a crop |
| Wrong aspect from an API | Adaptive ratio follows the input image | Pass the ratio explicitly on every clip |
| Stale endpoint behaviour | Provider catalog changes both ways | Re-inspect the schema before each build |
