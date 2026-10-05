# Asset Management Guide: Images, SVG, WebP, Fonts & Static Files

Comprehensive guide for managing frontend assets (images, icons, fonts, video) with a focus on performance, accessibility, and maintainability.

---

## 1. Asset Types & Use Cases

| Asset Type | Format | Use Case | Size Target |
|------------|--------|----------|-------------|
| **Raster Images** | WebP, AVIF, JPEG, PNG | Photos, complex graphics | <200KB |
| **Vector Graphics** | SVG | Icons, logos, illustrations | <50KB |
| **Fonts** | WOFF2, WOFF | Typography | <100KB per weight |
| **Videos** | MP4 (H.264), WebM | Hero backgrounds, demos | <5MB |
| **Documents** | PDF | Whitepapers, guides | <2MB |
| **Audio** | MP3, OGG | Notifications, podcasts | <500KB |

---

## 2. Required Assets Checklist (Pre-Launch)

### 2.1 Brand Identity Assets (MANDATORY)

| Asset | Format | Sizes | Purpose |
|-------|--------|-------|---------|
| **Logo Primary** | SVG + PNG | Vector + 512px, 256px, 128px | Website header, email signatures |
| **Logo Icon** | SVG + PNG | 512px, 256px, 128px, 64px, 32px | Social profiles, app icon, favicon base |
| **Logo Monochrome** | SVG + PNG | Same as primary | Dark mode, print, watermarks |
| **Wordmark** | SVG + PNG | Vector + 256px height | Tight horizontal spaces, footer |
| **Favicon Package** | ICO + PNG | See 2.2 below | Browser tabs, bookmarks |

**File Naming:**
```
/public/logo/
├── logo-primary.svg          // Full color vector
├── logo-primary-512.png      // Raster fallback
├── logo-icon.svg             // Icon only (square)
├── logo-icon-512.png
├── logo-monochrome-white.svg // For dark backgrounds
└── logo-wordmark.svg
```

---

### 2.2 Favicon Package (MANDATORY)

**Required Sizes** (comprehensive browser support):
```
/public/
├── favicon.ico                  // 16x16 + 32x32 multi-size ICO (IE11, legacy)
├── favicon-16x16.png
├── favicon-32x32.png
├── apple-touch-icon.png         // 180x180 (iOS home screen)
├── android-chrome-192x192.png   // PWA icon
├── android-chrome-512x512.png   // PWA splash screen
└── safari-pinned-tab.svg        // Safari tab icon (monochrome)
```

**Generation Tool** (auto-generates all sizes):
```bash
# Install
npm install -g sharp-cli

# Generate from single high-res PNG (1024x1024)
sharp logo-icon-1024.png -o favicon-16x16.png --resize 16
sharp logo-icon-1024.png -o favicon-32x32.png --resize 32
sharp logo-icon-1024.png -o apple-touch-icon.png --resize 180
sharp logo-icon-1024.png -o android-chrome-192x192.png --resize 192
sharp logo-icon-1024.png -o android-chrome-512x512.png --resize 512
```

**Or use online generator**: https://realfavicongenerator.net

**HTML `<head>` tags** (Next.js `app/layout.tsx`):
```tsx
export const metadata = {
  icons: {
    icon: [
      { url: '/favicon-16x16.png', sizes: '16x16', type: 'image/png' },
      { url: '/favicon-32x32.png', sizes: '32x32', type: 'image/png' },
    ],
    apple: '/apple-touch-icon.png',
  },
};
```

---

### 2.3 Social Media Assets (MANDATORY for Marketing)

> **Note**: Code examples in this section use Indonesian locale content (FreePajak tax app). Replace all text with your target language.

| Asset | Size | Format | Purpose |
|-------|------|--------|---------|
| **Open Graph Image** | 1200×630px | JPG/PNG | Facebook, LinkedIn, Twitter link previews |
| **Twitter Card Image** | 1200×675px (16:9) | JPG/PNG | Twitter link previews |
| **Profile Picture** | 400×400px (1:1) | JPG/PNG | Social media profiles |
| **Cover Photo (Twitter)** | 1500×500px | JPG/PNG | Twitter header |
| **Cover Photo (LinkedIn)** | 1584×396px | JPG/PNG | LinkedIn company page |
| **Cover Photo (Facebook)** | 820×312px | JPG/PNG | Facebook page |

**File Structure:**
```
/public/social/
├── og-image.jpg              // 1200×630 (default Open Graph)
├── og-image-home.jpg         // Per-page OG images (optional)
├── og-image-pricing.jpg
├── twitter-card.jpg          // 1200×675
├── profile-picture.jpg       // 400×400
└── cover-twitter.jpg         // 1500×500
```

**Next.js Metadata** (per page):
```tsx
// app/page.tsx
export const metadata = {
  openGraph: {
    title: 'FreePajak - Kalkulator Pajak Freelancer',
    description: 'Hitung 3 skema pajak sekaligus, hemat jutaan rupiah.',
    images: [
      {
        url: 'https://freepajak.com/social/og-image.jpg',
        width: 1200,
        height: 630,
        alt: 'FreePajak Dashboard',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'FreePajak - Kalkulator Pajak Freelancer',
    description: 'Hitung 3 skema pajak sekaligus, hemat jutaan rupiah.',
    images: ['https://freepajak.com/social/twitter-card.jpg'],
  },
};
```

---

### 2.4 PWA Assets (OPTIONAL — For Mobile App Experience)

**Web App Manifest** (`public/manifest.json`):
```json
{
  "name": "FreePajak",
  "short_name": "FreePajak",
  "description": "Kalkulator pajak freelancer Indonesia",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#0891B2",
  "icons": [
    {
      "src": "/android-chrome-192x192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "/android-chrome-512x512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any maskable"
    }
  ]
}
```

**Link in HTML**:
```tsx
// app/layout.tsx
export const metadata = {
  manifest: '/manifest.json',
};
```

---

### 2.5 UI Assets (Product Screenshots, Marketing)

| Asset | Size | Format | Purpose |
|-------|------|--------|---------|
| **Hero Image** | 1920×1080px | WebP + JPG | Landing page hero section |
| **Product Screenshots** | 1440×900px (16:10) | WebP + PNG | Features section, marketing |
| **Dashboard Mockup** | 1920×1080px | WebP + PNG | Homepage, demo video |
| **Mobile Screenshot** | 375×812px (iPhone 13) | PNG | App Store, mobile features |
| **Tutorial GIFs** | 800×600px | GIF/MP4 | How-to guides, tooltips |
| **Icon Set** | 24×24px base | SVG | UI icons (check, close, arrow, etc.) |

**Recommended Tools**:
- **Screenshots**: Cleanshot X (Mac), Flameshot (Linux/Windows)
- **Mockups**: Figma Device Mockups, Mockuuups.studio
- **GIF/Video**: ScreenToGif, Loom (screen recording)

---

### 2.6 Email Assets

| Asset | Size | Format | Purpose |
|-------|------|--------|---------|
| **Email Header Logo** | 600×100px | PNG | Email templates, newsletters |
| **Email Footer Logo** | 200×50px | PNG | Email signatures |
| **Product Icons (Email)** | 64×64px | PNG | Feature callouts in emails |

**Email-Safe Image Guidelines**:
- Max width: 600px (Outlook constraint)
- Format: PNG or JPG (avoid WebP — poor email client support)
- Inline images: <100KB total per email
- Alt text mandatory (image blocking common)

---

### 2.7 Legal & SEO Assets

| Asset | Format | Purpose |
|-------|--------|---------|
| **robots.txt** | TXT | Search engine crawling rules |
| **sitemap.xml** | XML | SEO — list all pages for Google |
| **humans.txt** | TXT | Credits for developers/designers (optional) |
| **security.txt** | TXT | Security disclosure contact (optional) |

**`public/robots.txt`**:
```txt
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /api/

Sitemap: https://freepajak.com/sitemap.xml
```

**`app/sitemap.ts`** (Next.js auto-generated):
```typescript
import { MetadataRoute } from 'next';

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    {
      url: 'https://freepajak.com',
      lastModified: new Date(),
      changeFrequency: 'daily',
      priority: 1,
    },
    {
      url: 'https://freepajak.com/pricing',
      lastModified: new Date(),
      changeFrequency: 'weekly',
      priority: 0.8,
    },
    {
      url: 'https://freepajak.com/blog',
      lastModified: new Date(),
      changeFrequency: 'daily',
      priority: 0.7,
    },
  ];
}
```

---

### 2.8 Complete Asset Inventory Template

**Pre-Launch Checklist** (copy to project README):

```markdown
## Asset Checklist

### Brand Identity
- [ ] Logo SVG (primary, icon, monochrome, wordmark)
- [ ] Logo PNG (512px, 256px, 128px, 64px, 32px)
- [ ] Brand color palette (design system tokens)

### Favicon Package
- [ ] favicon.ico (16x16 + 32x32)
- [ ] favicon-16x16.png
- [ ] favicon-32x32.png
- [ ] apple-touch-icon.png (180x180)
- [ ] android-chrome-192x192.png
- [ ] android-chrome-512x512.png
- [ ] safari-pinned-tab.svg

### Social Media
- [ ] Open Graph image (1200×630px)
- [ ] Twitter card image (1200×675px)
- [ ] Profile picture (400×400px)
- [ ] Cover photos (Twitter, LinkedIn, Facebook)

### UI Assets
- [ ] Hero image (1920×1080px, WebP + JPG)
- [ ] Product screenshots (3-5 key screens)
- [ ] Dashboard mockup (1920×1080px)
- [ ] Mobile screenshots (375×812px)
- [ ] Icon set (24×24px SVG, ~20 icons)
- [ ] Empty state illustrations (3-5 states)
- [ ] Loading animations (optional)

### Email
- [ ] Email header logo (600×100px PNG)
- [ ] Email footer logo (200×50px PNG)
- [ ] Email template tested (Gmail, Outlook, Apple Mail)

### Legal & SEO
- [ ] robots.txt configured
- [ ] sitemap.xml generated
- [ ] security.txt (if collecting user data)

### PWA (Optional)
- [ ] manifest.json
- [ ] Service worker configured
- [ ] Offline fallback page
```

---

## 2. Image Optimization Strategy

### 2.1 Format Selection (Decision Tree)

```
Q: Is it a photo or complex image (many colors)?
├─ Yes → WebP (primary) + JPEG (fallback)
└─ No → Lanjut Q2

Q: Is it a simple graphic (logo, icon, illustration)?
├─ Yes → SVG (vector, scalable)
└─ No → Lanjut Q3

Q: Does it need transparency?
├─ Yes → WebP with alpha OR PNG-8
└─ No → JPEG (lossy, smaller file size)
```

**Format Comparison**:
| Format | Use Case | Pros | Cons | Size vs JPEG |
|--------|----------|------|------|--------------|
| **WebP** | Modern photos, thumbnails | 25-35% smaller than JPEG, supports transparency | Not supported in IE11 | -30% |
| **AVIF** | Next-gen photos (2024+) | 50% smaller than JPEG | Limited browser support (<90%) | -50% |
| **JPEG** | Photos (fallback) | Universal support | No transparency | Baseline |
| **PNG-8** | Icons with transparency | Lossless, indexed colors | Larger than WebP | +50% |
| **SVG** | Logos, icons, illustrations | Infinite scalability, small size | Not for photos | Varies |

**Recommendation (2026)**:
- **Primary**: WebP (95% browser support)
- **Fallback**: JPEG (100% support)
- **Future**: AVIF (when support >95%, ~2027)

---

### 2.2 Compression & Sizing

**Compression Tools**:
```bash
# CLI (Sharp — fastest)
npm install -g sharp-cli
sharp input.jpg -o output.webp --webp-quality 80

# GUI (ImageOptim — Mac)
# Drag & drop, auto-compresses 30-70% lossless

# Online (Squoosh — Google)
# https://squoosh.app
```

**Quality Settings**:
| Use Case | JPEG Quality | WebP Quality | File Size Impact |
|----------|--------------|--------------|------------------|
| **Hero images** | 85-90 | 80-85 | Acceptable quality, -40% vs raw |
| **Thumbnails** | 75-80 | 70-75 | Slight quality loss, -60% |
| **Background images** | 70-75 | 65-70 | Subtle blur OK, -70% |
| **Product photos** | 85-90 | 80-85 | High quality needed |

**Responsive Image Sizes**:
Generate multiple sizes for responsive loading:
```bash
# Generate 3 sizes: small (640w), medium (1024w), large (1920w)
sharp hero.jpg -o hero-640.webp --resize 640 --webp-quality 80
sharp hero.jpg -o hero-1024.webp --resize 1024 --webp-quality 80
sharp hero.jpg -o hero-1920.webp --resize 1920 --webp-quality 80
```

**Naming Convention**:
```
[name]-[width]w.[format]
hero-640w.webp
hero-1024w.webp
hero-1920w.webp
hero-fallback.jpg  // For <picture> fallback
```

---

### 2.3 Next.js Image Component (Recommended)

**Built-in Optimization** (auto-generates WebP + responsive sizes):
```tsx
import Image from 'next/image';

export function Hero() {
  return (
    <div className="relative h-screen">
      <Image
        src="/images/hero.jpg"
        alt="Tax planning dashboard"
        fill
        priority  // LCP optimization (preload)
        quality={85}
        sizes="100vw"  // Responsive size hint
        className="object-cover"
      />
    </div>
  );
}
```

**Static Import** (Local images):
```tsx
import heroImage from '@/public/images/hero.jpg';

<Image
  src={heroImage}
  alt="..."
  placeholder="blur"  // Auto-generated low-res blur
  priority
/>
```

**Remote Images** (External CDN):
```tsx
// next.config.js
module.exports = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'cdn.example.com',
        pathname: '/images/**',
      },
    ],
    formats: ['image/webp', 'image/avif'],  // Enable AVIF
  },
};

// Component
<Image
  src="https://cdn.example.com/images/photo.jpg"
  alt="..."
  width={1200}
  height={800}
  sizes="(max-width: 768px) 100vw, 50vw"
/>
```

**Manual `<picture>` Tag** (Full control):
```tsx
<picture>
  <source
    srcSet="/images/hero-640w.webp 640w, /images/hero-1024w.webp 1024w, /images/hero-1920w.webp 1920w"
    type="image/webp"
    sizes="100vw"
  />
  <source
    srcSet="/images/hero-640w.jpg 640w, /images/hero-1024w.jpg 1024w, /images/hero-1920w.jpg 1920w"
    type="image/jpeg"
    sizes="100vw"
  />
  <img
    src="/images/hero-1024w.jpg"
    alt="Tax planning dashboard"
    loading="lazy"
    decoding="async"
    className="w-full h-auto"
  />
</picture>
```

---

## 3. SVG Optimization

### 3.1 Clean & Minify SVG

**Problem**: Exports from Figma/Illustrator often contain metadata bloat (300KB → 30KB after cleanup).

**Solution**: SVGO (SVG Optimizer)
```bash
npm install -g svgo

# Single file
svgo input.svg -o output.svg

# Batch (folder)
svgo -f ./raw-svg -o ./optimized-svg
```

**SVGO Config** (`svgo.config.js`):
```javascript
module.exports = {
  multipass: true,
  plugins: [
    'removeDoctype',
    'removeXMLProcInst',
    'removeComments',
    'removeMetadata',
    'removeEditorsNSData',
    'cleanupAttrs',
    'mergeStyles',
    'inlineStyles',
    'minifyStyles',
    'cleanupIds',
    'removeUselessDefs',
    'cleanupNumericValues',
    'convertColors',
    'removeUnknownsAndDefaults',
    'removeNonInheritableGroupAttrs',
    'removeUselessStrokeAndFill',
    'removeViewBox',  // REMOVE if you need responsive SVG
    'cleanupEnableBackground',
    'removeHiddenElems',
    'removeEmptyText',
    'convertShapeToPath',
    'convertEllipseToCircle',
    'moveElemsAttrsToGroup',
    'moveGroupAttrsToElems',
    'collapseGroups',
    'convertPathData',
    'convertTransform',
    'removeEmptyAttrs',
    'removeEmptyContainers',
    'mergePaths',
    'removeUnusedNS',
    'sortDefsChildren',
    'removeTitle',  // KEEP if you need accessibility
    'removeDesc',
  ],
};
```

---

### 3.2 Inline SVG vs External SVG

**Inline SVG** (Embed in HTML):
```tsx
// Pros: No HTTP request, can manipulate with CSS/JS
// Cons: Bloats HTML, not cacheable, repeated icons waste bytes

export function CheckIcon() {
  return (
    <svg className="w-5 h-5 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
    </svg>
  );
}
```

**External SVG** (Separate file):
```tsx
// Pros: Cacheable, reusable, smaller HTML
// Cons: Extra HTTP request (mitigated by HTTP/2 multiplexing)

<img src="/icons/check.svg" alt="Check" className="w-5 h-5" />
```

**SVG Sprite** (Best for many icons):
```html
<!-- public/icons-sprite.svg -->
<svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
  <symbol id="icon-check" viewBox="0 0 24 24">
    <path d="M5 13l4 4L19 7" />
  </symbol>
  <symbol id="icon-cross" viewBox="0 0 24 24">
    <path d="M6 18L18 6M6 6l12 12" />
  </symbol>
</svg>

<!-- Usage in HTML -->
<svg className="w-5 h-5"><use href="/icons-sprite.svg#icon-check" /></svg>
```

**React SVG Component Library** (Type-safe):
```bash
# Install SVGR (converts SVG to React components)
npm install --save-dev @svgr/webpack

# next.config.js
module.exports = {
  webpack(config) {
    config.module.rules.push({
      test: /\.svg$/,
      use: ['@svgr/webpack'],
    });
    return config;
  },
};

// Usage
import CheckIcon from '@/icons/check.svg';

<CheckIcon className="w-5 h-5 text-green-500" />
```

---

### 3.3 SVG Accessibility

**Always include** `<title>` or `aria-label`:
```tsx
// Decorative icon (no alt needed)
<svg aria-hidden="true" className="w-5 h-5">
  <path d="..." />
</svg>

// Meaningful icon (needs alt)
<svg role="img" aria-labelledby="check-title" className="w-5 h-5">
  <title id="check-title">Verified</title>
  <path d="..." />
</svg>

// Or use aria-label
<svg role="img" aria-label="Verified" className="w-5 h-5">
  <path d="..." />
</svg>
```

---

## 4. Font Management

### 4.1 Font Loading Strategy

**Problem**: Custom fonts block text rendering (FOIT — Flash of Invisible Text).

**Solution**: `font-display: swap` + preload critical fonts.

**Next.js Font Optimization** (Recommended):
```tsx
// app/layout.tsx
import { Inter, JetBrains_Mono } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700'],
  display: 'swap',
  variable: '--font-inter',
});

const jetbrainsMono = JetBrains_Mono({
  subsets: ['latin'],
  weight: ['400', '700'],
  display: 'swap',
  variable: '--font-jetbrains-mono',
});

export default function RootLayout({ children }) {
  return (
    <html lang="id" className={`${inter.variable} ${jetbrainsMono.variable}`}>
      <body className="font-sans">{children}</body>  {/* font-sans uses --font-inter */}
    </html>
  );
}
```

**Self-Hosted Fonts** (Privacy + Performance):
```css
/* app/globals.css */
@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-Regular.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-SemiBold.woff2') format('woff2');
  font-weight: 600;
  font-style: normal;
  font-display: swap;
}
```

**Preload Critical Fonts** (LCP optimization):
```tsx
// app/layout.tsx
export default function RootLayout({ children }) {
  return (
    <html lang="id">
      <head>
        <link
          rel="preload"
          href="/fonts/Inter-Regular.woff2"
          as="font"
          type="font/woff2"
          crossOrigin="anonymous"
        />
      </head>
      <body>{children}</body>
    </html>
  );
}
```

---

### 4.2 Font Subsetting (Reduce File Size)

**Problem**: Full Inter font = 200KB; Latin subset = 60KB.

**Tool**: `glyphhanger` (extract used characters)
```bash
npm install -g glyphhanger

# Generate subset for Latin characters only
glyphhanger --subset=fonts/Inter-Regular.ttf --formats=woff2 --whitelist=U+0000-00FF
```

**Google Fonts Subsetting** (Automatic):
```html
<!-- Only load Latin characters -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&subset=latin&display=swap" rel="stylesheet">
```

---

### 4.3 Variable Fonts (Future-Proof)

**Benefit**: 1 file contains all weights (400, 500, 600, 700) instead of 4 files.

```css
@font-face {
  font-family: 'InterVariable';
  src: url('/fonts/Inter-Variable.woff2') format('woff2');
  font-weight: 100 900;  /* Full weight range */
  font-display: swap;
}

body {
  font-family: 'InterVariable', sans-serif;
  font-weight: 450;  /* Interpolate between standard weights */
}
```

**Caveat**: Variable fonts file size ~150KB (vs 4×50KB = 200KB for static fonts) — save 25%.

---

## 5. Asset Storage & Delivery

### 5.1 Folder Structure (Next.js)

```
project/
├── public/                   # Static assets (served from root /)
│   ├── images/
│   │   ├── hero-640w.webp
│   │   ├── hero-1024w.webp
│   │   ├── hero-1920w.webp
│   │   └── og-image.jpg     # Open Graph image
│   ├── icons/
│   │   ├── favicon.ico
│   │   ├── apple-touch-icon.png
│   │   └── icon-sprite.svg
│   ├── fonts/
│   │   ├── Inter-Regular.woff2
│   │   └── JetBrains-Mono-Regular.woff2
│   ├── videos/
│   │   └── demo.mp4
│   └── documents/
│       └── whitepaper.pdf
└── src/
    └── assets/               # Assets imported in code (optimized by bundler)
        ├── logo.svg
        └── brand-colors.ts
```

**Naming Convention**:
- Lowercase, kebab-case: `hero-image.jpg`, `product-thumbnail.webp`
- Semantic names: `dashboard-screenshot.png` (NOT `img_1234.png`)
- Include dimensions for multiple sizes: `avatar-64w.png`, `avatar-128w.png`

---

### 5.2 CDN Strategy

**Local Assets** (< 1MB total):
- Store in `public/` folder
- Vercel auto-serves from edge (no extra CDN needed)

**Heavy Assets** (> 1MB OR user-uploaded):
- Use external CDN/object storage:
  - **Cloudflare R2** (S3-compatible, zero egress fees)
  - **AWS S3 + CloudFront**
  - **Supabase Storage** (built-in CDN)
  - **ImageKit** (image CDN with on-the-fly transformation)

**Supabase Storage Example**:
```typescript
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_KEY!);

// Upload
async function uploadAvatar(file: File, userId: string) {
  const filePath = `avatars/${userId}-${Date.now()}.jpg`;
  
  const { data, error } = await supabase.storage
    .from('public-assets')
    .upload(filePath, file, {
      cacheControl: '3600',  // 1 hour cache
      upsert: false
    });
  
  if (error) throw error;
  
  // Get public URL
  const { data: { publicUrl } } = supabase.storage
    .from('public-assets')
    .getPublicUrl(filePath);
  
  return publicUrl;
}

// Transform on-the-fly (Supabase Image Transformation)
const thumbnail = `${publicUrl}?width=300&height=300&quality=80`;
```

---

### 5.3 Cache Headers

**Static Assets** (immutable):
```
Cache-Control: public, max-age=31536000, immutable
```

**User-Uploaded Content** (change frequently):
```
Cache-Control: public, max-age=3600, must-revalidate
```

**Next.js Config**:
```javascript
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/images/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
      {
        source: '/fonts/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
    ];
  },
};
```

---

## 6. Performance Checklist

**Pre-Launch Audit**:
- [ ] All images <200KB (hero images <500KB)
- [ ] WebP format used for all photos (JPEG fallback)
- [ ] SVG icons optimized with SVGO (<10KB each)
- [ ] Fonts preloaded (only critical weights: 400, 600)
- [ ] Lazy loading enabled for below-fold images
- [ ] `<picture>` tag with responsive sizes for hero images
- [ ] Alt text present on all `<img>` tags (except decorative)
- [ ] Cache headers configured (immutable for /images, /fonts)
- [ ] Lighthouse score >90 (Performance, Accessibility)

**Tools**:
- **Lighthouse CI** (automated performance monitoring)
- **WebPageTest** (real-world loading simulation)
- **ImageOptim** (batch compression GUI)
- **Squoosh** (visual quality comparison)

---

## 7. Accessibility Requirements

**Images**:
- [ ] All content images have descriptive `alt` text
- [ ] Decorative images: `alt=""` OR `aria-hidden="true"`
- [ ] Complex infographics: `alt` + `longdesc` link to full description

**SVG Icons**:
- [ ] Decorative icons: `aria-hidden="true"`
- [ ] Functional icons (buttons): `aria-label` OR `<title>`

**Contrast**:
- [ ] Logo works on white & dark backgrounds (test both)
- [ ] Text overlays on images: contrast ratio ≥4.5:1 (use semi-transparent overlay if needed)

---

## 8. Troubleshooting

### Issue: Next.js Image Optimization not working on Vercel
**Cause**: Image source hostname not in `remotePatterns`
**Fix**: Add domain to `next.config.js` (see section 2.3)

### Issue: SVG not displaying in Safari
**Cause**: Missing `viewBox` attribute
**Fix**: Add `viewBox="0 0 24 24"` to `<svg>` tag

### Issue: Fonts loading slowly (FOIT)
**Cause**: Missing `font-display: swap`
**Fix**: Add to `@font-face` rule OR use Next.js font optimization

### Issue: Images blurry on Retina displays
**Cause**: Wrong `sizes` attribute in `<Image>`
**Fix**: Use `sizes="(max-width: 768px) 100vw, 50vw"` for responsive sizing

### Issue: Lighthouse "Serve images in next-gen formats" warning
**Cause**: Still using JPEG/PNG only
**Fix**: Convert to WebP (see section 2.1)

---

**Tools Summary**:
- **Compression**: Sharp CLI, ImageOptim, Squoosh
- **SVG Optimization**: SVGO, SVGR (React components)
- **Font Subsetting**: glyphhanger, Google Fonts API
- **CDN**: Cloudflare R2, Supabase Storage, ImageKit
- **Monitoring**: Lighthouse CI, WebPageTest, Vercel Analytics
