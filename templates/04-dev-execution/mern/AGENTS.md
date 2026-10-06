# AI Agent Guidelines - MERN Stack Project

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

## Code Style Rules
1. **TypeScript**: Strict mode, no `any` types
2. **Async/Await**: Use async/await over callbacks
3. **File Naming**: kebab-case for files, PascalCase for components
4. **MongoDB**: Always use Mongoose (no raw MongoDB driver queries)
5. **Error Handling**: Use express-async-handler or try/catch in routes

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
