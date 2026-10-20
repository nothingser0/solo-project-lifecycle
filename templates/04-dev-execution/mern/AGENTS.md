# AI Agent Guidelines - MERN Stack Project

## 0. Execution Protocol — One Task Per Turn (NON-NEGOTIABLE)

- **`TODO.md` is the queue.** Work its task list **one task at a time**.
- **Per task**: implement ONLY that task → run that task's `Verify` command → paste the raw output → report task ID + files touched + result → 🛑 **END TURN**.
- **Do NOT** start the next task, open a new sprint, or batch task IDs — unless the human names the specific task IDs to run in one instruction.
- **`[x]` is the human's mark, never yours.** Only after the human confirms may you record `Approved: <date> by <name>` in that task's `Evidence`.
- **If a spec, schema, or requirement is missing, STOP and ask** — never invent it to keep the queue moving.
- **Never run `git commit`, `git push`, or `git tag`** — hand the change to the human for review and commit.

---

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Express.js**: https://expressjs.com/
- **MongoDB**: https://www.mongodb.com/docs/
- **Mongoose**: https://mongoosejs.com/docs/
- **React**: https://react.dev
- **Node.js**: https://nodejs.org/docs/

**Why**: MERN components evolve independently. This project uses:
- MongoDB 7.x or 8.x (check package.json)
- Express 4.x or 5.x
- React 18.x or 19.x
- Node.js 20.x or 22.x

### Version-Specific Syntax Enforcement

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **Mongoose Schema** | https://mongoosejs.com/docs/guide.html | Schema types evolve |
| **Express Middleware** | https://expressjs.com/en/guide/using-middleware.html | Async handler patterns |
| **MongoDB Aggregation** | https://www.mongodb.com/docs/manual/aggregation/ | Pipeline operators change |
| **React Hooks** | https://react.dev/reference/react | Hook rules evolve |

**Enforcement Rules**:
1. Check MongoDB docs for aggregation pipeline operators
2. Verify Express async error handling pattern
3. Use Mongoose schema validation (not application-level only)
4. Run `npm list` to confirm installed versions

## Anti-AI-Slop Directives (ENFORCED)
1. **BANNED: Redundant Explanatory Comments** — do not narrate obvious code.
   - ❌ `// Increment counter`  |  `// Import React`
   - ❌ Stub comments: `// TODO: implement this later`  |  `// Add your logic here`
   - ✅ Comment ONLY non-obvious business logic, domain formulas, or deliberate workarounds.
   - ✅ Never leave commented-out dead code — delete it (git remembers).
2. **BANNED: Silent Failures** — no empty catch/except blocks; log, rethrow, or return a typed error.
3. **BANNED: Dead Code & Unused Imports** — remove unused variables, imports, and unreachable branches.
4. **RACE CONDITIONS (MANDATORY for any shared-state mutation)** — protect every read-modify-write on inventory, balances, counters, booking slots, or status transitions:
   - Use a DB transaction + row lock (SELECT ... FOR UPDATE), or a unique constraint / idempotency key.
   - Never "check then act" across two separate queries without a lock or constraint.
   - Webhooks and payment callbacks MUST be idempotent (dedupe on provider event ID).
   - Frontend: disable the submit button while pending + use an idempotency key to prevent double-submit.
5. **BANNED: Hallucinated APIs/Packages** — verify every import exists before using it.

---

## Code Style Rules
1. **TypeScript**: Strict mode, no `any` types
2. **Async/Await**: Use async/await over callbacks
3. **File Naming**: kebab-case for files, PascalCase for components
4. **MongoDB**: Always use Mongoose (no raw MongoDB driver queries)
5. **Error Handling**: Use express-async-handler or try/catch in routes
6. **Hydration-Free Rendering (SSR-Safe React)**: when the app renders on the server, the first client render must match it exactly. Never compute `Date.now()`/`new Date()`/`Math.random()` or read `localStorage`/`window` during render — do it in `useEffect` with an explicit default render, or serve the value from the API. Every formatter passes an explicit `locale` **and** `timeZone` (`Intl.DateTimeFormat('id-ID', { timeZone: 'Asia/Jakarta' })`); bare `toLocaleString()` diverges between server and browser. Never import a browser-only module into the server bundle. Full ladder: `references/technical/HYDRATION_FREE_RENDERING.md`.

## Database (MongoDB + Mongoose)
- **Schema**: Define with Mongoose schemas (validation, indexes, methods)
- **Migrations**: Use migrate-mongo or manual scripts
- **Indexes**: Add on frequently queried fields
- **Validation**: Schema-level + application-level

## Testing
- **Backend**: Jest + Supertest
- **Frontend**: Vitest + Testing Library
- **Run**: `npm test`

## Security
- **NoSQL Injection**: Sanitize inputs with mongo-sanitize
- **JWT**: Use for authentication (store in HttpOnly cookies)
- **CORS**: Configure allowed origins
- ❌ No secrets in client code

## Build Commands
- **Dev**: `npm run dev` (concurrently runs backend + frontend)
- **Backend**: `npm run server`
- **Frontend**: `npm run client`
- **Build**: `npm run build`
