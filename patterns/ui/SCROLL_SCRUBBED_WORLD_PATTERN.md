# Scroll-Scrubbed Cinematic World Pattern

> **Module**: M04 (UI/UX Landing Page) & M06 (Frontend Engineering)  
> **Source**: Adapted from Apple-style continuous flight landing pages and `oso95/scroll-world`.  
> **Objective**: Deliver seamless 3D/video fly-through hero experiences driven entirely by user scroll position with zero framework lock-in and zero transition pops.

---

## 1. Architectural Overview & Physics

A scroll-scrubbed world replaces traditional autoplaying video or heavy WebGL canvas scenes with **scroll-driven video playback**:
* The video never autoplays; its `currentTime` is mathematically bound to viewport scroll progress:
  $$\text{video.currentTime} = \text{scrollProgress} \times \text{video.duration}$$
* As the user scrolls down, the virtual camera flies continuously through 3D diorama scenes without cuts.
* Scrolling back up scrubs the camera backwards automatically.

---

## 2. The Frame-Identical Seam Rule (Zero-Pop Transition)

The single most common failure in scroll cinematics is a visual flicker ("pop") between consecutive camera clips. To ensure 100% seamless continuity:

```
[Scene A Dive Clip] ──────────► [Connector Clip A->B] ──────────► [Scene B Dive Clip]
      │                               ▲     │                               ▲
      └─ Last Frame (Frame N) ────────┘     └─ Last Frame (Frame M) ────────┘
         (Identical pixel handoff)             (Identical pixel handoff)
```

1. **Extract Exact Pixel Boundary**: The starting image of `Connector A->B` MUST be the exact rendered last frame of `Scene A`.
2. **Target End-Frame**: The ending frame of `Connector A->B` MUST be the exact rendered first frame of `Scene B`.
3. **No Mixed Dimensions**: All video segments MUST share identical resolution (e.g. 1080p 16:9 for desktop, 1080x1920 9:16 for mobile).

---

## 3. Lightweight Vanilla JS Scrub Engine

This engine operates with zero external dependencies and runs in React, Next.js, Vue, or static HTML:

```javascript
class ScrollScrubEngine {
  constructor(videoElement, containerElement) {
    this.video = videoElement;
    this.container = containerElement;
    this.isTicking = false;

    // Ensure video is ready for seeking
    this.video.pause();
    this.video.addEventListener('loadedmetadata', () => this.update());
    window.addEventListener('scroll', () => this.onScroll(), { passive: true });
  }

  onScroll() {
    if (!this.isTicking) {
      window.requestAnimationFrame(() => {
        this.update();
        this.isTicking = false;
      });
      this.isTicking = true;
    }
  }

  update() {
    if (!this.video.duration) return;

    const rect = this.container.getBoundingClientRect();
    const totalScrollable = this.container.offsetHeight - window.innerHeight;
    if (totalScrollable <= 0) return;

    // Calculate progress 0.0 -> 1.0 clamped
    const currentScroll = -rect.top;
    const progress = Math.min(Math.max(currentScroll / totalScrollable, 0), 1);

    // Fast-seek or direct assignment with requestVideoFrameCallback if available
    this.video.currentTime = progress * this.video.duration;
  }
}
```

---

## 4. Production Performance & Fallback Guards

1. **Keyframe Density (GOP Interval)**:
   - Standard videos have keyframes every 250 frames, causing choppy lag during backward scrolling.
   - For scroll scrubbing, encode videos with an intra-keyframe interval of **at least 1 keyframe every 5–10 frames** (`ffmpeg -g 10 -keyint_min 5`) to ensure silky 60fps scrub response in both directions.
2. **Mobile Bandwidth Fallback**:
   - On slow connections or low-power mobile mode, fallback gracefully to responsive WebP static diorama stills with sticky text overlays instead of loading a 30MB video payload.
3. **Hardware Acceleration**:
   - Video element must declare `playsinline muted preload="auto"` with CSS `transform: translateZ(0)` to lock rendering onto the GPU compositor thread.
