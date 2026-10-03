# UI Component & Animation Library Reference

Comprehensive catalog of production-ready components, animation libraries, and design style implementations for modern web apps.

**Last Updated**: 2026-09-29  
**Target**: Solo devs, small teams building SaaS/web apps

---

## Table of Contents

1. [Complex UI Components](#1-complex-ui-components)
2. [Animation Libraries](#2-animation-libraries)
3. [Design Style Guides](#3-design-style-guides)
4. [Integration Patterns](#4-integration-patterns)
5. [Component Decision Matrix](#5-component-decision-matrix)

---

## 1. Complex UI Components

### 1.1 Kanban Board

**Use Case**: Task management, project tracking, workflow visualization

#### Option A: dnd-kit (Recommended — Accessibility-first)
```bash
npm install @dnd-kit/core @dnd-kit/sortable @dnd-kit/utilities
```

**Features**:
- ✅ Keyboard navigation (WCAG AAA)
- ✅ Touch support (mobile)
- ✅ Virtual scrolling (1000+ items)
- ✅ Zero dependencies

**Example**:
```tsx
import { DndContext, closestCenter } from '@dnd-kit/core';
import { SortableContext, verticalListSortingStrategy } from '@dnd-kit/sortable';

export function KanbanBoard() {
  const [columns, setColumns] = useState({
    todo: ['task-1', 'task-2'],
    doing: ['task-3'],
    done: ['task-4']
  });

  function handleDragEnd(event) {
    const { active, over } = event;
    // Update columns state
  }

  return (
    <DndContext collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
      {Object.entries(columns).map(([columnId, tasks]) => (
        <Column key={columnId} id={columnId}>
          <SortableContext items={tasks} strategy={verticalListSortingStrategy}>
            {tasks.map(taskId => <Task key={taskId} id={taskId} />)}
          </SortableContext>
        </Column>
      ))}
    </DndContext>
  );
}
```

**Alternatives**:
- `react-beautiful-dnd` (deprecated by Atlassian, avoid)
- `react-dnd` (complex API, overkill for Kanban)

**Resources**:
- Docs: https://docs.dndkit.com
- Example: https://master--5fc05e08a4a65d0021ae0bf2.chromatic.com

---

#### Option B: Pragmatic Drag and Drop (Atlassian)
```bash
npm install @atlaskit/pragmatic-drag-and-drop
```

**Features**:
- ✅ Framework-agnostic (React, Vue, Svelte)
- ✅ 4.7KB gzipped (smallest)
- ✅ Smooth animations

**When to use**: Multi-framework support needed

---

### 1.2 Calendar & Date Picker

**Use Case**: Scheduling, booking, event management

#### Option A: React Big Calendar (Full Calendar View)
```bash
npm install react-big-calendar date-fns
```

**Features**:
- ✅ Month/Week/Day/Agenda views
- ✅ Drag-to-create events
- ✅ Recurring events
- ✅ Timezone support

**Example**:
```tsx
import { Calendar, dateFnsLocalizer } from 'react-big-calendar';
import { format, parse, startOfWeek, getDay } from 'date-fns';
import 'react-big-calendar/lib/css/react-big-calendar.css';

const locales = { 'id': require('date-fns/locale/id') };
const localizer = dateFnsLocalizer({ format, parse, startOfWeek, getDay, locales });

export function AppointmentCalendar() {
  const [events, setEvents] = useState([
    {
      title: 'Meeting with Client',
      start: new Date(2026, 8, 29, 10, 0),
      end: new Date(2026, 8, 29, 11, 0),
      resource: { status: 'confirmed' }
    }
  ]);

  return (
    <Calendar
      localizer={localizer}
      events={events}
      startAccessor="start"
      endAccessor="end"
      style={{ height: 600 }}
      views={['month', 'week', 'day', 'agenda']}
    />
  );
}
```

**Resources**:
- Docs: https://jquense.github.io/react-big-calendar/examples
- Styling: Custom CSS themes available

---

#### Option B: React Day Picker (Date Picker Only)
```bash
npm install react-day-picker date-fns
```

**Features**:
- ✅ 8KB gzipped (lightweight)
- ✅ Range selection
- ✅ Disabled dates
- ✅ Customizable UI

**When to use**: Simple date picker (no full calendar needed)

**Example**:
```tsx
import { DayPicker } from 'react-day-picker';
import 'react-day-picker/dist/style.css';

export function DateRangePicker() {
  const [range, setRange] = useState<DateRange | undefined>();

  return (
    <DayPicker
      mode="range"
      selected={range}
      onSelect={setRange}
      disabled={{ before: new Date() }}
    />
  );
}
```

---

#### Option C: FullCalendar (Premium — $395/dev)
**When to use**: Enterprise features needed (resource scheduling, timeline view, Google Calendar sync)

---

### 1.3 Data Tables

**Use Case**: Dashboard, admin panel, data management

#### Option A: TanStack Table (Recommended — Headless)
```bash
npm install @tanstack/react-table
```

**Features**:
- ✅ Headless (bring your own UI)
- ✅ Sorting, filtering, pagination
- ✅ Column resizing, pinning, reordering
- ✅ Virtual scrolling (1M+ rows)
- ✅ TypeScript-first

**Example**:
```tsx
import { useReactTable, getCoreRowModel, flexRender } from '@tanstack/react-table';

export function InvoiceTable({ data }) {
  const columns = [
    { accessorKey: 'invoice_id', header: 'Invoice ID' },
    { accessorKey: 'date', header: 'Date' },
    { accessorKey: 'amount', header: 'Amount', cell: info => `Rp${info.getValue().toLocaleString()}` }
  ];

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel()
  });

  return (
    <table>
      <thead>
        {table.getHeaderGroups().map(headerGroup => (
          <tr key={headerGroup.id}>
            {headerGroup.headers.map(header => (
              <th key={header.id}>
                {flexRender(header.column.columnDef.header, header.getContext())}
              </th>
            ))}
          </tr>
        ))}
      </thead>
      <tbody>
        {table.getRowModel().rows.map(row => (
          <tr key={row.id}>
            {row.getVisibleCells().map(cell => (
              <td key={cell.id}>
                {flexRender(cell.column.columnDef.cell, cell.getContext())}
              </td>
            ))}
          </tr>
        ))}
      </tbody>
    </table>
  );
}
```

**Resources**:
- Docs: https://tanstack.com/table/latest
- Examples: https://tanstack.com/table/latest/docs/framework/react/examples/basic

---

#### Option B: AG Grid (Enterprise — $999/dev/year)
**When to use**: Excel-like features needed (cell editing, grouping, pivoting, charts)

---

### 1.4 Charts & Data Visualization

**Use Case**: Dashboard analytics, reporting

#### Option A: Recharts (Recommended — Simple)
```bash
npm install recharts
```

**Features**:
- ✅ Built on D3 (battle-tested)
- ✅ Responsive
- ✅ 8 chart types (Line, Bar, Area, Pie, Radar, Scatter, Funnel, Treemap)
- ✅ Composable API

**Example**:
```tsx
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

export function IncomeChart({ data }) {
  return (
    <ResponsiveContainer width="100%" height={300}>
      <LineChart data={data}>
        <CartesianGrid strokeDasharray="3 3" />
        <XAxis dataKey="month" />
        <YAxis />
        <Tooltip formatter={(value) => `Rp${value.toLocaleString()}`} />
        <Legend />
        <Line type="monotone" dataKey="income" stroke="#0891B2" strokeWidth={2} />
      </LineChart>
    </ResponsiveContainer>
  );
}
```

**Resources**:
- Docs: https://recharts.org/en-US/
- Gallery: https://recharts.org/en-US/examples

---

#### Option B: Chart.js (Canvas-based — Better performance)
```bash
npm install react-chartjs-2 chart.js
```

**When to use**: Large datasets (10K+ points), real-time updates

---

#### Option C: D3.js (Low-level — Full control)
```bash
npm install d3
```

**When to use**: Custom visualizations (network graphs, force-directed layouts, geographical maps)

---

### 1.5 Rich Text Editor

**Use Case**: Blog CMS, note-taking, document editing

#### Option A: Tiptap (Recommended — Headless)
```bash
npm install @tiptap/react @tiptap/starter-kit
```

**Features**:
- ✅ Headless (full UI control)
- ✅ Markdown shortcuts
- ✅ Slash commands
- ✅ Collaboration (Yjs)
- ✅ 100+ extensions

**Example**:
```tsx
import { useEditor, EditorContent } from '@tiptap/react';
import StarterKit from '@tiptap/starter-kit';

export function RichTextEditor({ content, onChange }) {
  const editor = useEditor({
    extensions: [StarterKit],
    content,
    onUpdate: ({ editor }) => onChange(editor.getHTML())
  });

  return (
    <div>
      <Toolbar editor={editor} />
      <EditorContent editor={editor} />
    </div>
  );
}
```

**Resources**:
- Docs: https://tiptap.dev
- Examples: https://tiptap.dev/examples

---

#### Option B: Lexical (Meta/Facebook)
```bash
npm install lexical @lexical/react
```

**When to use**: Facebook-like features needed (mentions, hashtags, embeds)

---

#### Option C: Quill (Simple — Pre-built UI)
```bash
npm install react-quill quill
```

**When to use**: Minimal customization needed, drop-in editor

---

### 1.6 File Upload (Drag & Drop)

**Use Case**: Document upload, image gallery, multi-file input

#### Option A: React Dropzone (Recommended)
```bash
npm install react-dropzone
```

**Features**:
- ✅ Drag & drop + click to browse
- ✅ File type validation
- ✅ Max size validation
- ✅ Image preview
- ✅ Multiple files

**Example**:
```tsx
import { useDropzone } from 'react-dropzone';

export function FileUploader({ onUpload }) {
  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    accept: { 'image/*': ['.png', '.jpg', '.jpeg', '.webp'] },
    maxSize: 5242880, // 5MB
    onDrop: (acceptedFiles) => {
      // Upload to Supabase Storage
      acceptedFiles.forEach(file => onUpload(file));
    }
  });

  return (
    <div {...getRootProps()} className={isDragActive ? 'border-blue-500' : 'border-gray-300'}>
      <input {...getInputProps()} />
      <p>Drag & drop files, or click to browse</p>
    </div>
  );
}
```

**Resources**:
- Docs: https://react-dropzone.js.org
- Examples: https://react-dropzone.js.org/#section-examples

---

### 1.7 Command Palette (⌘K)

**Use Case**: Power user shortcuts, global search, navigation

#### Option A: cmdk (Recommended — Used by Vercel, Linear)
```bash
npm install cmdk
```

**Features**:
- ✅ Fuzzy search
- ✅ Keyboard navigation
- ✅ Nested commands
- ✅ 2KB gzipped

**Example**:
```tsx
import { Command } from 'cmdk';

export function CommandPalette({ open, setOpen }) {
  return (
    <Command.Dialog open={open} onOpenChange={setOpen}>
      <Command.Input placeholder="Type a command or search..." />
      <Command.List>
        <Command.Empty>No results found.</Command.Empty>
        
        <Command.Group heading="Navigation">
          <Command.Item onSelect={() => router.push('/dashboard')}>
            Dashboard
          </Command.Item>
          <Command.Item onSelect={() => router.push('/calculations')}>
            Tax Calculations
          </Command.Item>
        </Command.Group>
        
        <Command.Group heading="Actions">
          <Command.Item onSelect={() => setTheme('dark')}>
            Toggle Dark Mode
          </Command.Item>
        </Command.Group>
      </Command.List>
    </Command.Dialog>
  );
}
```

**Resources**:
- Docs: https://cmdk.paco.me
- Demo: https://cmdk.paco.me

---

### 1.8 Toast Notifications

**Use Case**: Success/error feedback, system alerts

#### Option A: Sonner (Recommended — Best DX)
```bash
npm install sonner
```

**Features**:
- ✅ Auto-dismiss
- ✅ Promise toasts (loading → success/error)
- ✅ Action buttons
- ✅ Swipe to dismiss (mobile)

**Example**:
```tsx
import { toast, Toaster } from 'sonner';

// In app root
export default function App() {
  return (
    <>
      <Toaster position="top-right" />
      {/* rest of app */}
    </>
  );
}

// Anywhere in app
function handleSave() {
  toast.promise(
    saveToDatabase(),
    {
      loading: 'Saving...',
      success: 'Calculation saved!',
      error: 'Failed to save. Please try again.'
    }
  );
}
```

**Resources**:
- Docs: https://sonner.emilkowal.ski
- Demo: https://sonner.emilkowal.ski

---

### 1.9 Form Builder (Multi-step Forms)

**Use Case**: Onboarding wizard, tax calculation flow, checkout

#### Option A: React Hook Form + Zod
```bash
npm install react-hook-form zod @hookform/resolvers
```

**Example** (Multi-step tax calculation):
```tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const step1Schema = z.object({
  income: z.number().min(0),
  employmentType: z.enum(['pegawai', 'bukan_pegawai', 'freelancer'])
});

const step2Schema = z.object({
  maritalStatus: z.enum(['TK', 'K']),
  dependents: z.number().min(0).max(3)
});

export function TaxCalculationWizard() {
  const [step, setStep] = useState(1);
  const form = useForm({
    resolver: zodResolver(step === 1 ? step1Schema : step2Schema),
    mode: 'onChange'
  });

  function onSubmit(data) {
    if (step === 1) {
      setStep(2);
    } else {
      // Final submit
      calculateTax(data);
    }
  }

  return (
    <form onSubmit={form.handleSubmit(onSubmit)}>
      {step === 1 && <Step1Fields register={form.register} errors={form.formState.errors} />}
      {step === 2 && <Step2Fields register={form.register} errors={form.formState.errors} />}
      
      <Button type="submit">{step === 1 ? 'Next' : 'Calculate'}</Button>
    </form>
  );
}
```

---

### 1.10 Modal / Dialog

**Use Case**: Confirmation, detail view, form popups

#### Option A: Radix UI Dialog (Recommended — Headless)
```bash
npm install @radix-ui/react-dialog
```

**Features**:
- ✅ Accessible (focus trap, Esc to close)
- ✅ Headless (full style control)
- ✅ Portal rendering (no z-index issues)

**Example**:
```tsx
import * as Dialog from '@radix-ui/react-dialog';

export function DeleteConfirmDialog({ open, onOpenChange, onConfirm }) {
  return (
    <Dialog.Root open={open} onOpenChange={onOpenChange}>
      <Dialog.Portal>
        <Dialog.Overlay className="fixed inset-0 bg-black/50" />
        <Dialog.Content className="fixed top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 bg-white p-6 rounded-lg">
          <Dialog.Title>Delete Calculation?</Dialog.Title>
          <Dialog.Description>
            This action cannot be undone. Are you sure?
          </Dialog.Description>
          <div className="flex gap-3 mt-4">
            <Dialog.Close asChild>
              <Button variant="ghost">Cancel</Button>
            </Dialog.Close>
            <Button variant="destructive" onClick={onConfirm}>Delete</Button>
          </div>
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  );
}
```

---

## 2. Animation Libraries

### 2.1 Framer Motion (Recommended — General Purpose)

**Use Case**: Page transitions, micro-interactions, gestures

```bash
npm install framer-motion
```

**Features**:
- ✅ Declarative API
- ✅ Layout animations (auto-animate position changes)
- ✅ Gesture detection (drag, hover, tap)
- ✅ SVG path animations
- ✅ Scroll-triggered animations

**Example** (Page transition):
```tsx
import { motion, AnimatePresence } from 'framer-motion';

export function PageTransition({ children }) {
  return (
    <AnimatePresence mode="wait">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        exit={{ opacity: 0, y: -20 }}
        transition={{ duration: 0.2 }}
      >
        {children}
      </motion.div>
    </AnimatePresence>
  );
}
```

**Example** (Card hover):
```tsx
<motion.div
  whileHover={{ scale: 1.02, boxShadow: '0 10px 40px rgba(0,0,0,0.1)' }}
  whileTap={{ scale: 0.98 }}
  transition={{ type: 'spring', stiffness: 300 }}
>
  <Card />
</motion.div>
```

**Resources**:
- Docs: https://www.framer.com/motion/
- Examples: https://www.framer.com/motion/examples/

**When to use**: 95% of animation needs (page transitions, hover effects, modal animations)

---

### 2.2 GSAP (GreenSock Animation Platform)

**Use Case**: Timeline-based animations, complex sequences, scroll-triggered narratives

```bash
npm install gsap
```

**Features**:
- ✅ ScrollTrigger (scroll-based animations)
- ✅ Timeline sequencing
- ✅ Morphing (shape tweening)
- ✅ Best performance (60fps guaranteed)

**Example** (Scroll-triggered reveal):
```tsx
import { useGSAP } from '@gsap/react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export function FeatureSection() {
  const ref = useRef(null);

  useGSAP(() => {
    gsap.from('.feature-card', {
      scrollTrigger: {
        trigger: ref.current,
        start: 'top 80%',
        end: 'bottom 20%',
        toggleActions: 'play none none reverse'
      },
      y: 100,
      opacity: 0,
      stagger: 0.2,
      duration: 0.8,
      ease: 'power3.out'
    });
  }, { scope: ref });

  return (
    <div ref={ref}>
      <div className="feature-card">Feature 1</div>
      <div className="feature-card">Feature 2</div>
      <div className="feature-card">Feature 3</div>
    </div>
  );
}
```

**When to use**: Marketing landing pages, scroll-driven storytelling, complex timeline animations

**Resources**:
- Docs: https://gsap.com/docs/v3/
- ScrollTrigger demos: https://gsap.com/docs/v3/Plugins/ScrollTrigger/

---

### 2.3 Three.js (3D Graphics)

**Use Case**: 3D product showcase, interactive backgrounds, data visualization in 3D

```bash
npm install three @react-three/fiber @react-three/drei
```

**Features**:
- ✅ WebGL 3D rendering
- ✅ React-three-fiber (declarative React API)
- ✅ Physics, post-processing, effects

**Example** (Rotating 3D logo):
```tsx
import { Canvas } from '@react-three/fiber';
import { OrbitControls, useGLTF } from '@react-three/drei';

function Logo() {
  const { scene } = useGLTF('/logo.glb');
  return <primitive object={scene} scale={2} />;
}

export function HeroSection() {
  return (
    <Canvas camera={{ position: [0, 0, 5], fov: 50 }}>
      <ambientLight intensity={0.5} />
      <pointLight position={[10, 10, 10]} />
      <Logo />
      <OrbitControls enableZoom={false} />
    </Canvas>
  );
}
```

**When to use**: 
- ✅ 3D product configurators (e.g., tax bracket visualization in 3D)
- ✅ Immersive hero sections
- ✅ Data visualization (3D charts, networks)
- ❌ **Skip for fintech/tax apps** (too flashy, distracts from content)

**Resources**:
- Docs: https://threejs.org/docs/
- React Three Fiber: https://docs.pmnd.rs/react-three-fiber
- Examples: https://codesandbox.io/examples/package/@react-three/fiber

---

### 2.4 Lottie (JSON Animations)

**Use Case**: Designer-created animations, micro-interactions, empty states

```bash
npm install lottie-react
```

**Features**:
- ✅ After Effects → JSON export
- ✅ Small file size (vector-based)
- ✅ Retina-ready

**Example**:
```tsx
import Lottie from 'lottie-react';
import loadingAnimation from './loading.json';

export function LoadingState() {
  return <Lottie animationData={loadingAnimation} loop style={{ width: 200 }} />;
}
```

**When to use**: Loading states, empty states, success confirmations

**Resources**:
- Free animations: https://lottiefiles.com
- Docs: https://airbnb.io/lottie

---

### 2.5 Auto-Animate (Minimal JS)

**Use Case**: Simple list animations, DOM changes

```bash
npm install @formkit/auto-animate
```

**Features**:
- ✅ Zero config (1 line of code)
- ✅ Auto-detects DOM changes
- ✅ 2KB gzipped

**Example**:
```tsx
import { useAutoAnimate } from '@formkit/auto-animate/react';

export function TodoList({ todos }) {
  const [parent] = useAutoAnimate();

  return (
    <ul ref={parent}>
      {todos.map(todo => (
        <li key={todo.id}>{todo.text}</li>
      ))}
    </ul>
  );
}
```

**When to use**: Quick animations without config (add/remove items)

---

## 3. Design Style Guides

### 3.1 Minimalist (Recommended for FreePajak)

**Characteristics**:
- Flat colors (no gradients)
- Whitespace-heavy (breathing room)
- 1-2 accent colors max
- Subtle shadows (0-4px blur)
- Clean typography (Inter, SF Pro, Roboto)

**Color Palette**:
```css
/* Background */
--bg-primary: #FFFFFF;
--bg-secondary: #F9FAFB;
--bg-dark: #09090B;

/* Text */
--text-primary: #18181B;
--text-secondary: #52525B;
--text-tertiary: #A1A1AA;

/* Accent */
--accent-primary: #0891B2; /* Cyan-600 */
--accent-hover: #0E7490;   /* Cyan-700 */

/* Borders */
--border-default: #E4E4E7; /* Zinc-200 */
--border-focus: #0891B2;
```

**Component Style**:
```tsx
// Card
<div className="bg-white border border-zinc-200 rounded-lg p-6 hover:shadow-sm transition-shadow">
  <h3 className="text-lg font-semibold text-zinc-900">Title</h3>
  <p className="text-sm text-zinc-600 mt-2">Description</p>
</div>

// Button
<button className="bg-cyan-600 hover:bg-cyan-700 text-white px-4 py-2 rounded-md font-medium transition-colors">
  Calculate Tax
</button>
```

**Example Sites**:
- Linear (https://linear.app)
- Stripe (https://stripe.com)
- Vercel (https://vercel.com)

---

### 3.2 Glassmorphism

**Characteristics**:
- Frosted glass effect (backdrop-blur)
- Semi-transparent backgrounds (rgba)
- Subtle borders (1px white/light)
- Layered depth

**CSS**:
```css
.glass-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px) saturate(150%);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}
```

**Example**:
```tsx
<div className="relative overflow-hidden">
  {/* Background (gradient or image) */}
  <div className="absolute inset-0 bg-gradient-to-br from-cyan-400 to-blue-500" />
  
  {/* Glass card */}
  <div className="relative backdrop-blur-md bg-white/10 border border-white/20 rounded-xl p-6">
    <h3 className="text-white font-semibold">Tax Summary</h3>
    <p className="text-white/80 mt-2">Total: Rp5,000,000</p>
  </div>
</div>
```

**When to use**:
- ✅ Marketing landing pages
- ✅ Premium/luxury brands
- ❌ **Avoid for fintech/tax apps** (readability issues, accessibility concerns)

**Example Sites**:
- Apple (https://apple.com)
- iOS design language

---

### 3.3 Brutalism

**Characteristics**:
- Bold typography (heavy weights, large sizes)
- Raw, unpolished aesthetics
- High contrast (black/white, primary colors)
- Exposed structure (visible borders, grids)
- Asymmetric layouts

**Color Palette**:
```css
--bg: #FFFFFF;
--text: #000000;
--accent: #FF0000; /* or #00FF00, #0000FF */
--border: #000000;
```

**Component Style**:
```tsx
// Brutal card
<div className="border-4 border-black bg-white p-6 shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
  <h3 className="text-3xl font-black uppercase">CALCULATE</h3>
  <p className="text-lg font-bold mt-4">YOUR TAXES NOW</p>
</div>

// Brutal button
<button className="bg-black text-white px-8 py-4 text-xl font-black uppercase border-4 border-black hover:bg-white hover:text-black transition-colors">
  START
</button>
```

**When to use**:
- ✅ Portfolio sites
- ✅ Art/design studios
- ❌ **Avoid for fintech** (too aggressive, low trust)

**Example Sites**:
- Balenciaga (fashion)
- Bloomberg Businessweek

---

### 3.4 Neumorphism (Soft UI)

**Characteristics**:
- Soft shadows (inset + outset)
- Monochromatic palette
- Skeuomorphic (mimics physical buttons)
- Subtle depth

**CSS**:
```css
.neomorphic-card {
  background: #E0E5EC;
  border-radius: 20px;
  box-shadow: 
    9px 9px 16px rgba(163, 177, 198, 0.6),
    -9px -9px 16px rgba(255, 255, 255, 0.5);
}

.neomorphic-button {
  background: #E0E5EC;
  box-shadow: 
    inset 3px 3px 6px rgba(163, 177, 198, 0.4),
    inset -3px -3px 6px rgba(255, 255, 255, 0.8);
}
```

**When to use**:
- ✅ Mobile apps (iOS-style)
- ❌ **Avoid for accessibility** (low contrast, hard to distinguish clickable elements)

**Example Sites**:
- Neumorphism.io (generator)

---

### 3.5 Interactive Design (Video/Image Backgrounds)

**Use Case**: Marketing landing pages, portfolio, storytelling


> **Note**: Example uses Indonesian locale content ("Mulai Sekarang" = Get Started). Replace with your target language.

#### Pattern A: Video Background (Hero Section)

```tsx
export function HeroWithVideo() {
  return (
    <div className="relative h-screen overflow-hidden">
      {/* Video background */}
      <video
        autoPlay
        loop
        muted
        playsInline
        className="absolute inset-0 w-full h-full object-cover"
      >
        <source src="/hero-video.mp4" type="video/mp4" />
      </video>
      
      {/* Overlay (improve text readability) */}
      <div className="absolute inset-0 bg-black/50" />
      
      {/* Content */}
      <div className="relative z-10 flex items-center justify-center h-full">
        <div className="text-center text-white">
          <h1 className="text-6xl font-bold">Hitung Pajak Freelancer</h1>
          <p className="text-xl mt-4">3 skema, 1 klik, hemat jutaan</p>
          <button className="mt-8 bg-cyan-600 hover:bg-cyan-700 px-8 py-4 rounded-lg font-semibold">
            Mulai Sekarang
          </button>
        </div>
      </div>
    </div>
  );
}
```

**Performance tips**:
- Use WebM (50% smaller than MP4)
- Max 1080p resolution
- 5-10 second loops
- Add poster image for loading state

---

#### Pattern B: Parallax Scrolling (Image Layers)
```tsx
import { motion, useScroll, useTransform } from 'framer-motion';

export function ParallaxSection() {
  const { scrollY } = useScroll();
  const y1 = useTransform(scrollY, [0, 1000], [0, -200]); // Slower
  const y2 = useTransform(scrollY, [0, 1000], [0, -400]); // Faster

  return (
    <div className="relative h-screen overflow-hidden">
      {/* Background layer (slow) */}
      <motion.div style={{ y: y1 }} className="absolute inset-0">
        <img src="/bg-layer-1.jpg" alt="" className="w-full h-full object-cover" />
      </motion.div>
      
      {/* Foreground layer (fast) */}
      <motion.div style={{ y: y2 }} className="absolute inset-0">
        <img src="/bg-layer-2.png" alt="" className="w-full h-full object-cover" />
      </motion.div>
      
      {/* Content (fixed) */}
      <div className="relative z-10 flex items-center justify-center h-full">
        <h2 className="text-5xl font-bold">Scroll for Effect</h2>
      </div>
    </div>
  );
}
```

**When to use**:
- ✅ Marketing landing pages
- ✅ Portfolio sites
- ❌ **Avoid for SaaS apps** (distracts from core functionality)

---

### 3.6 Dark Mode

**Implementation** (Next.js + Tailwind):
```tsx
// app/providers.tsx
import { ThemeProvider } from 'next-themes';

export function Providers({ children }) {
  return (
    <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
      {children}
    </ThemeProvider>
  );
}

// components/theme-toggle.tsx
import { useTheme } from 'next-themes';

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();

  return (
    <button onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}>
      {theme === 'dark' ? '☀️' : '🌙'}
    </button>
  );
}
```

**Tailwind Config**:
```css
/* tailwind.config.js */
module.exports = {
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        background: 'var(--background)',
        foreground: 'var(--foreground)'
      }
    }
  }
};

/* globals.css */
:root {
  --background: #FFFFFF;
  --foreground: #18181B;
}

.dark {
  --background: #09090B;
  --foreground: #FAFAFA;
}
```

**Component Usage**:
```tsx
<div className="bg-white dark:bg-zinc-900 text-zinc-900 dark:text-white">
  <p>This text adapts to theme</p>
</div>
```

---

## 4. Integration Patterns

### 4.1 FreePajak Recommended Stack

**Core UI**: shadcn/ui (minimalist, accessible)
**Animation**: Framer Motion (page transitions, micro-interactions)
**Charts**: Recharts (tax breakdown visualization)
**Forms**: React Hook Form + Zod (multi-step tax calculation)
**Tables**: TanStack Table (invoice history, calculation log)
**Toast**: Sonner (save confirmations)
**Modal**: Radix UI Dialog (delete confirmation, detail view)

**Avoid**:
- ❌ Three.js (too flashy for fintech)
- ❌ Glassmorphism (readability issues)
- ❌ Brutalism (low trust for tax app)
- ❌ Video backgrounds (distracts from calculations)

---

### 4.2 Component Bundle Size Budget

| Component | Library | Size (gzipped) | Budget |
|-----------|---------|----------------|--------|
| Animation | Framer Motion | 32KB | ✅ Acceptable |
| Charts | Recharts | 65KB | ✅ Acceptable |
| Forms | React Hook Form | 8KB | ✅ Lightweight |
| Tables | TanStack Table | 15KB | ✅ Lightweight |
| Toast | Sonner | 4KB | ✅ Tiny |
| Command Palette | cmdk | 2KB | ✅ Tiny |
| **AVOID** | GSAP (full) | 57KB | ⚠️ Only if heavy animation needed |
| **AVOID** | Three.js | 580KB | ❌ Too heavy for fintech |
| **AVOID** | AG Grid | 800KB | ❌ Overkill for simple tables |

**Target**: <150KB total for all UI libraries

---

## 5. Component Decision Matrix

| Need | Recommended | Alternative | Avoid |
|------|-------------|-------------|-------|
| **Kanban** | dnd-kit | Pragmatic DnD | react-beautiful-dnd (deprecated) |
| **Calendar** | React Big Calendar | React Day Picker | FullCalendar (paid) |
| **Table** | TanStack Table | AG Grid (if Excel features needed) | Material-UI DataGrid (heavy) |
| **Charts** | Recharts | Chart.js (performance) | D3 raw (too complex) |
| **Rich Text** | Tiptap | Lexical (Meta) | Quill (limited customization) |
| **File Upload** | React Dropzone | Uppy (full UI) | Custom (accessibility issues) |
| **Command** | cmdk | - | Custom modal (poor UX) |
| **Toast** | Sonner | React Hot Toast | Custom (accessibility) |
| **Modal** | Radix UI Dialog | Headless UI | Bootstrap Modal (jQuery) |
| **Animation** | Framer Motion | GSAP (timeline) | jQuery animate (outdated) |
| **3D** | Three.js (if needed) | - | WebGL raw (too low-level) |
| **Lottie** | lottie-react | - | GIF (large file size) |

---

## 6. Resources

**Component Libraries**:
- shadcn/ui: https://ui.shadcn.com
- Radix UI: https://radix-ui.com
- Headless UI: https://headlessui.com

**Animation**:
- Framer Motion: https://framer.com/motion
- GSAP: https://gsap.com
- Lottie: https://lottiefiles.com

**Design Inspiration**:
- Minimalist: Linear, Stripe, Vercel
- Glassmorphism: Apple, iOS
- Brutalism: Bloomberg, Balenciaga
- Interactive: Awwwards.com, Codrops

**Performance**:
- Bundle analyzer: https://bundlephobia.com
- Lighthouse: https://pagespeed.web.dev
