# Motion Design & Interactive Animation Taxonomy

> **Standard Reference**: Technical specifications, implementations, and delivery formats for 60+ modern web, mobile, and digital motion design effects. Mapped to the `solo-project-lifecycle` framework (`docs/specs/COMPONENT_REQUIREMENTS.md` Section 3, `docs/design/inspiration/notes.md`, and `M06-FE-02`).

---

## 1. Complete Motion & Animation Taxonomy

### 1.1 Web UI & Interaction Primitives (Code-First / CSS & Spring Physics)
1. **Parallax Scrolling**: Multi-layer background/foreground moving at differing velocity ratios (`useScroll` + `useTransform`).
2. **Hero Animation (Fly Animation)**: Staggered entrance of key headline, badges, and floating assets upon page mount.
3. **Hover Effects**: Micro-elevation, gradient border shift, and scale-up on pointer hover (`whileHover={{ scale: 1.02 }}`).
4. **Micro-Interactions**: Direct feedback for clicks, toggles, likes, and state changes (100–200ms).
5. **Morphing**: Seamless SVG path interpolation (`d` attribute morphing via Flubber or GSAP MorphSVG).
6. **Match Cut**: Visual transition where a component in screen A seamlessly morphs into a container in screen B (Framer Motion `layoutId`).
7. **Wipe / Slide**: Directional screen curtain reveal (left-to-right, clip-path circle wipe).
8. **Kinetic Typography**: Expressive, dynamic animated typography (variable font weight oscillation, kinetic letter shifts).
9. **Liquid Motion**: Gooey, fluid organic blending transitions using SVG filters (`feGaussianBlur` + `feColorMatrix`).
10. **Glitch Effect**: Intentional digital artifacting, RGB split displacement, and scanline flickering via CSS keyframes.
11. **Staggered Animation (Sequential Reveal)**: Coordinated sequential entrance of lists or child nodes (`staggerChildren: 0.05`).
12. **Skeleton / Shimmer Loading**: Continuous wave gradient passing across placeholder shapes (`background-position` sweep).
13. **Pull-to-Refresh Animation**: Elastic over-drag trigger with circular spinner or custom SVG character deformation.
14. **Overlay & Obscuration**: Dimmed or blurred backdrop canvas (`backdrop-blur-md` + opacity ease) isolating active dialogs.
15. **Sticky / Magnetic Motion**: Interactive elements snapping or magnetically pulling toward cursor position within radius.
16. **Dolly & Zoom**: Camera focal distance shift or container scale transformation during scroll.
17. **Glassmorphism / Glossy Motion**: Realtime refraction and specular highlight sheen sweeping across frosted glass surfaces.
18. **Mega Menu Transitions**: Height/width auto-interpolating navigation dropdown container adapting to varying sub-content.
19. **Hero Animated Visual**: Ambient motion in the key visual container (mesh gradient drift, floating cards).
20. **Scrollytelling (Scroll-Triggered Animation)**: Viewport-scrubbed narrative flow pinning elements while content unfolds.
21. **Swipe-to-Action (Contextual Swiping)**: Horizontal swipe revealing delete/archive action drawers with spring threshold.
22. **Bottom Sheet Slide-In**: Touch-draggable modal sliding up from screen bottom with snap-points.
23. **Drag-and-Drop Feedback**: Card lift, tilt, shadow expansion, and placeholder gap opening during layout reordering.
24. **Progress Indicators / Lottie Bar**: Segmented, circular, or bespoke animated completion bars.
25. **Interruptible Animation**: Animations that dynamically cancel or reverse without visual jumping when user inputs collide.
26. **Staggered Layout Reveal (Orchestration)**: Global orchestrator timing the sequence between navigation, hero, and sidebar.
27. **Parenting / Spatial Anchoring**: Child elements inheriting translation, rotation, or scale offsets from a primary anchor.
28. **Value Transition / Counter Easing**: Animated numeric roll/count-up (`requestAnimationFrame` easing) for dashboards.
29. **Spring Physics (Elastic Motion)**: Natural oscillation governed by `stiffness`, `damping`, and `mass` parameters.
30. **Card Flipping / Origami Fold**: 3D perspective fold (`rotateY(180deg)`) revealing card back or unfolded panel.
31. **Bento Grid Expansion**: Dynamic layout morph where a compact bento tile smoothly expands into a full view container.
32. **Infinite Horizontal Marquee**: Continuous seamless loop of partner logos or ticker text without stutter.
33. **Contextual Edge Swiping**: Mobile navigation gesture triggering page transitions from viewport screen edges.
34. **Pinch-to-Scale & Rotate**: Multi-touch gesture scaling and rotating images or canvas elements smoothly.
35. **Sticker / Peel-Off Transition**: Interactive peeling corner effect revealing content underneath with realistic shadow gradient.
36. **Ambient Background Motion / Aurora Drift**: Soft, slow-moving blurred gradient orbs floating in background canvas.
37. **Masked Reveal / Mouse Spotlight**: Radial gradient mask following mouse coordinates revealing hidden layers or grid lines.
38. **Idle Floating / Hover Levitation**: Gentle perpetual floating animation (`y: [0, -8, 0]`) simulating weightlessness.
39. **CSS Keyframes**: Performant, declarative GPU-accelerated transforms (`transform`, `opacity`) without JS overhead.
40. **Self-Drawing Lines (SVG Stroke Animation)**: SVG path tracing itself into view (`stroke-dasharray` and `stroke-dashoffset` interpolation).

---

### 1.2 Digital Motion Design & Narrative Assets (Runtimes, Engines, & Media)
41. **WebGL / Custom Shaders**: Fragment & vertex shaders rendering generative fluid, noise, or water ripple physics.
42. **Rive (State Machine Animation)**: Interactive vector motion reacting dynamically to runtime state inputs (cursor position, clicks, booleans).
43. **Lottie (Bodymovin)**: Vector animation JSON exported from After Effects, ideal for illustrations and icons.
44. **Cel Animation (Frame-by-Frame)**: Hand-drawn traditional animation sequences (rendered as APNG, WebP sequence, or spritesheet).
45. **Rigging Animation**: Skeletal joint hierarchy animating 2D character meshes with inverse kinematics.
46. **Isometric Motion**: 30-degree projected 3D perspective animation ideal for architectural, tech stack, and SaaS system visuals.
47. **Explainer Animation**: Narrative scene sequences synchronizing voiceover, text reveals, and conceptual diagrams.
48. **Logo Reveal / Brand Animation**: High-impact brand signature motion executed upon splash, onboarding, or hero mount.
49. **Animated Infographics**: Data charts with self-drawing axes, growing bars, and pulsing data nodes.
50. **2.5D Animation**: Layered flat 2D planes arranged in 3D perspective with virtual camera parallax.
51. **3.5D / Hybrid Animation**: Fusion of 2D cel/vector illustration mapped over 3D geometry and volumetric lighting.
52. **Character Motion Design**: Mascot and character micro-interactions conveying system emotion and user delight.
53. **Cinemagraph**: High-resolution looping photograph where a minor, isolated portion exhibits seamless video motion.
54. **Seamless Loops**: Flawless loop cycles with zero visual seams or cadence hiccups for backgrounds and waiting states.
55. **Broadcasting Graphics (Lower Thirds & Bumpers)**: News/streamer-style title bars, floating notification badges, and scene stinger transitions.
56. **Oddly Satisfying Simulation**: Mesmerizing physical simulations (falling dominoes, soft-body squish, perfect loop pendulum).
57. **Collage / Mixed Media Motion**: Stop-motion style blending paper cutouts, vintage photography, vector shapes, and real textures.
58. **Cloth & Soft-Body Physics**: Realtime or pre-baked textile waving, curtain swaying, and jelly deformation.
59. **Particle Systems**: GPU-calculated ambient dust, floating stars, confetti explosions, or smoke emitters.
60. **Depth Map 3D Photo**: 2D photograph converted into a 3D tilt scene using an AI-generated grayscale depth map.

---

## 2. Framework Implementation Mapping

| Category | Primary Runtime / Stack | Location in Framework |
|:---|:---|:---|
| **Web UI & Spring Physics** | Framer Motion, Tailwind CSS, Lucide | `src/components/ui/`, `TODO_TEMPLATE.md` (`M06-FE-02`) |
| **Interactive Vector Motion** | Rive Runtime (`@rive-app/react-canvas`) | `assets/media/*.riv` |
| **Vector Animation Clips** | Lottie React (`lottie-react` / dotLottie) | `assets/media/*.json`, `assets/media/*.lottie` |
| **3D & WebGL Shaders** | Three.js, React Three Fiber, Spline | `assets/media/*.splinecode`, `assets/media/*.glb` |
| **Video Loops & Cinemagraphs** | HTML5 `<video autoplay loop muted playsinline>` | `assets/media/*.mp4`, `assets/media/*.webm` |
