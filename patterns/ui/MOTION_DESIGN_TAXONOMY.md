# Motion Design & Interactive Animation Taxonomy

> **Standard Reference**: Technical specifications, implementations, and delivery formats for 70+ modern web, mobile, digital, and spatial motion design effects. Mapped to the `solo-project-lifecycle` framework (`docs/specs/COMPONENT_REQUIREMENTS.md` Section 3, `docs/design/inspiration/notes.md`, and `M06-FE-02`).
>
> **This is a catalogue, not a chooser.** 73 effects are listed below; the *selection* layer — which effect for which intent, four personality archetypes, emotion-to-motion mapping, stagger budgets — lives in [`references/design/MOTION_PERSONALITY_GUIDE.md`](../../references/design/MOTION_PERSONALITY_GUIDE.md). Timing values are governed by [`references/design/UI_MOTION_GUIDELINES.md`](../../references/design/UI_MOTION_GUIDELINES.md) §7.
>
> **Rule**: never pick an effect from this list first. Start from the intent (function / personality / story), then find the effect that serves it.

---

## 1. Animasi Berbasis Navigasi & Pengguliran (Scroll & Spatial)
1. **Parallax Scrolling**: Perbedaan kecepatan gerak antara lapisan latar belakang dan latar depan untuk menciptakan kedalaman visual (`useScroll` + `useTransform`).
2. **Scrollytelling (Scroll-Triggered Animation)**: Animasi yang berjalan secara progresif mengikuti pergerakan scroll pengguna untuk menceritakan produk.
3. **Horizontal Scroll Section**: Manipulasi halaman di mana scroll vertikal diubah menjadi pergeseran konten secara horizontal menyamping.
4. **Pinned Section / Sticky Scroll**: Efek mengunci posisi elemen visual utama sementara elemen teks di sebelahnya terus bergeser.
5. **Dolly & Zoom Navigation**: Kamera virtual yang seolah bergerak maju menembus atau mendekati objek untuk masuk ke sub-menu yang lebih dalam.
6. **Bento Grid Expansion**: Animasi tata letak di mana satu kotak bento meluas mengambil alih ruang di sekitarnya saat diklik.
7. **Infinite Horizontal Marquee**: Teks atau barisan logo yang berjalan menyamping secara melingkar tanpa henti (seamless loop).

---

## 2. Animasi Transisi Halaman & Elemen (Transitions & Layout)
8. **Hero Animation (Shared Element Transition / Fly Animation)**: Elemen visual (seperti foto produk/kartu) melesat dan membesar mulus dari katalog menuju detail page (Framer Motion `layoutId`).
9. **FLIP Transition (First, Last, Invert, Play)**: Teknik kalkulasi bounding rect awal dan akhir objek untuk transisi layout 60fps tanpa layout thrashing.
10. **Morphing States**: Perubahan bentuk satu komponen UI menjadi komponen lain secara organik (misalnya ikon menu hamburger ☰ berubah menjadi tanda silang ✕).
11. **Fab Morphing (Floating Action Button)**: Tombol bulat mengambang yang melebar dan bertransformasi menjadi lembar form/menu penuh saat diklik.
12. **Bottom Sheet Slide-In**: Panel menu atau opsi yang meluncur naik dari batas bawah layar dengan snap points.
13. **Sidebar Collapse / Expand**: Animasi panel navigasi samping menyusut menjadi ikon ramping atau melebar untuk memaksimalkan ruang kerja.
14. **Mega Menu Transitions**: Panel navigasi besar yang menginterpolasi tinggi/lebar secara dinamis mengikuti sub-menu yang disorot kursor.
15. **Accordion Elastic Stretch**: Animasi membuka menu lipat dengan pegas elastis yang mendorong elemen di bawahnya.
16. **Card Flipping / Origami Fold**: Komponen berputar 180 derajat (`rotateY(180deg)`) menampilkan informasi di bagian belakang dengan visual backface culling.
17. **Staggered Reveal (Sequential Animation)**: Elemen menu atau daftar kartu yang muncul berurutan satu per satu dengan jeda milidetik (`staggerChildren: 0.05`).
18. **Match Cut**: Elemen visual di scene A bertransformasi persis ke posisi geometri wadah baru di scene B.
19. **Wipe / Slide**: Tirai transisi berarah (left-to-right, diagonal, circle clip-path) untuk perpindahan tampilan.

---

## 3. Respons Sentuhan, Gestur, & Kursor (Gestures & Feedback)
20. **Hover States / Focus States**: Elevasi bayangan, pendaran warna border, atau skala instan (`whileHover={{ scale: 1.02 }}`).
21. **Sticky / Magnetic Cursor**: Kursor tetikus tersedot secara magnetis atau membesar saat mendekati tombol radius interaksi.
22. **Cursor Follower / Custom Trail**: Jejak partikel atau lingkaran fluida halus yang mengekor koordinat mouse.
23. **Swipe-to-Action (Contextual Swiping)**: Menggeser baris item pada mobile untuk memunculkan aksi kontekstual (hapus/arsip) dengan ambang batas pegas.
24. **Contextual Edge Swiping**: Gestur menarik pinggir layar untuk navigasi riwayat atau membuka drawer tersembunyi.
25. **Pinch-to-Scale & Rotate**: Gestur multi-touch memperbesar, memperkecil, atau memutar objek kanvas secara langsung.
26. **Drag-and-Drop Dropzone Glow**: Area target memancarkan cahaya, berdenyut, atau meluas ketika file diseret di atas layar.
27. **Sticker / Peel-Off Transition**: Notifikasi atau label sudut layar yang bisa "dikupas" atau diseret lepas layaknya stiker fisik.
28. **Haptic Sync Animation**: Animasi visual mikro yang ritmenya sinkron dengan motor getar haptic perangkat mobile.
29. **3D Card Tilt / Gyroscope Effect**: Kartu miring secara interaktif mengikuti koordinat pointer (desktop) atau sensor kemiringan giroskop (mobile).

---

## 4. Animasi Mikro & Status Sistem (Micro-interactions & Loading)
30. **Micro-interactions**: Respon visual instan seperti switch mode siang/malam, tombol bookmark mekar, atau checkbox centang (100–200ms).
31. **Skeleton / Shimmer Loading**: Gelombang gradasi abu-abu berdenyut lembut pada placeholder sebelum data asli selesai dimuat.
32. **Progress Indicators / Lottie Bar**: Animasi sirkular atau baris linier yang menunjukkan status persentase tugas secara real-time.
33. **Indeterminate vs Determinate Progress**: Perubahan mulus dari animasi garis tanpa ujung menjadi baris persentase linier terisi penuh.
34. **Success Tick / Error Shake**: Ikon centang mekar saat berhasil, atau form bergetar ke kanan-kiri (horizontal shake) saat validasi gagal.
35. **Contextual Trash Shrink**: Objek yang dihapus mengecil dan tersedot masuk ke dalam ikon tempat sampah.
36. **Cart Gamification / Wobble**: Ikon keranjang belanja melompat atau bergetar ceria saat barang ditambahkan.
37. **Voice Assistant Waveform**: Gelombang suara yang bergerak naik-turun merespons frekuensi audio pangguna.
38. **Form Validation Border Draw**: Garis tepi outline input digambar memutari kotak secara instan saat validasi aktif.
39. **Button Fill / Color Shift**: Tombol yang warnanya terisi penuh dari arah tertentu saat disorot kursor.

---

## 5. Logika Gerakan, Fisika, & Aksesibilitas (Core Architecture)
40. **Easing (Ease-In / Ease-Out / Cubic Bezier)**: Percepatan dan perlambatan objek meniru hukum fisika inersia.
41. **Spring Physics (Elastic Motion)**: Gerakan berbasis pegas alami (`stiffness`, `damping`, `mass`) tanpa batasan durasi kaku.
42. **Interruptible Animation**: Animasi yang bisa dibatalkan atau dibalikkan arahnya seketika tanpa visual glitch saat pangguna menginterupsi.
43. **Parenting / Spatial Anchoring**: Elemen anak otomatis mewarisi transformasi elemen induk secara proporsional.
44. **Value Transition / Counter Easing**: Animasi perubahan angka digital bergulir cepat (rolling counter) pada metrik saldo atau statistik.
45. **Obscuration & Dimming Layer**: Layar latar belakang tenggelam menjadi gelap atau buram (`backdrop-blur-md`) saat dialog muncul.
46. **Ambient Background Motion / Aurora Drift**: Gradasi warna latar belakang yang bergeser membaur perlahan menyerupai aurora.
47. **Self-Drawing Lines**: Outline ikon atau ilustrasi SVG yang digambar otomatis (`stroke-dashoffset`).
48. **Masked Reveal / Mouse Spotlight**: Radial mask mengikuti kursor membuka lapisan tersembunyi atau grid latar belakang.
49. **Idle Floating / Hover Levitation**: Gerakan melayang naik-turun halus (`y: [0, -8, 0]`) pada elemen kunci agar terkesan berbobot ringan.
50. **Window Snapping / Docking Transition**: Animasi halus saat jendela aplikasi ditarik ke tepi layar untuk mode split screen.
51. **Reduced-Motion Fallback (Accessibility)**: Otomatis mengganti gerakan dinamis dengan transisi cross-fade lembut jika pangguna mengaktifkan preferensi disabilitas gerak (`prefers-reduced-motion`).

---

## 6. AI, Spatial UI, & WebGL Shader Shifting (Next-Gen Interaction)
52. **Streaming/Generative Text Ripple**: Teks AI mengalir kata-demi-kata disertai pendaran cahaya (glow ripple) pada ujung kata yang sedang diproduksi.
53. **Intent-to-Action Shift (Command Palette Transition)**: Seluruh antarmuka menyusut ke latar belakang dan spotlight command AI membesar seketika.
54. **Confidence Level Pulse**: Indikator lingkaran hasil AI yang berdenyut tenang saat akurasi tinggi dan berkedip cepat saat ambigu.
55. **Reactive Margin Shifting**: Panel asisten AI meluncur dari tepi layar dan secara otomatis memampatkan lembar kerja utama tanpa menutupi konten.
56. **Gaze-Cursor Hover (Eye-Tracking Response)**: Tombol spatial UI menonjol ke depan (elevation) hanya dengan ditatap mata pengguna.
57. **Z-Axis Passthrough Depthing**: Jendela aplikasi spasial bergerak di sumbu Z di mana elemen latar berbaur dengan ruangan nyata pengguna.
58. **Spatial Gravity Snap**: Jendela digital spasial memantul lembut dan menempel (snap) mengikuti permukaan meja atau dinding fisik.
59. **Audio-Reactive Interface States**: Elemen UI berdenyut atau berubah ketebalannya dinamis mengikuti frekuensi mikrofon.
60. **Ambient Light Adaptive Easing**: Kecepatan animasi melambat otomatis di ruangan gelap agar mata tidak lelah.
61. **Thermal/Battery Throttling Fallback**: Penurunan frame rate otomatis (120Hz ke 60Hz) dan penyederhanaan gerak saat baterai kritis atau suhu perangkat tinggi.
62. **Liquid Gooey / Blob Effect**: Dua elemen lingkaran WebGL menyatu liat seperti tetesan cairan sebelum terpisah.
63. **Raymarching / SDF UI Transitions**: Transisi menggunakan Signed Distance Field mengubah ikon 2D menjadi geometri 3D presisi.
64. **Displacement Map Mouse Trail**: Gerakan kursor menciptakan riak distorsi gelombang air di atas media visual.

---

## 7. Media Naratif & Runtimes (Developer Hand-off)
65. **Lottie (JSON / dotLottie)**: Animasi vektor ringan hasil ekspor After Effects/Figma untuk ikon dan ilustrasi interaktif.
66. **CSS Keyframes**: Transformasi GPU-accelerated murni (`transform`, `opacity`) berkinerja tinggi tanpa dependensi JS.
67. **Hardware Acceleration Guardrail (`will-change: transform`)**: Gunakan `will-change` secara hemat hanya pada elemen yang aktif beranimasi untuk memicu kompositing layer GPU terpisah tanpa memicu memory leak pada browser mobile.
68. **WebGL / Three.js / Canvas Shaders**: Rendering interaktif 3D dan partikel berbasis akselerasi kartu grafis browser.
69. **Rive (State Machine)**: Animasi interaktif vektor dengan logika state bawaan yang bereaksi langsung terhadap data tanpa koding ulang.
70. **Kinetic Typography**: Eksplorasi tipografi kinetik (animasi bobot font variabel dan transformasi ritmis).
71. **Glitch Effect**: Efek distorsi digital, RGB split chromatic aberration, dan scanlines.
72. **Cinemagraph & Seamless Loops**: Video loop tanpa jeda visual untuk latar belakang hero visual.
73. **Cel / 2.5D / Isometric Motion**: Aset ilustrasi bergaya kartun frame-by-frame, proyeksi isometrik 30 derajat, atau multi-plane 2.5D.
