# Realtime Communication & Network Protocols Pattern

> **Module**: M05 (Architecture & Specs) & M06 (Development Execution)  
> **Source**: Adapted from a published system-design-101 curriculum & modern production transport engineering.  
> **Scope**: Authoritative engineering rules for selecting network protocols (SSE vs. WebSocket vs. Polling), designing Edge Reverse Proxy vs. API Gateway layers, and enforcing resilient connection lifecycles.

---

## 1. Realtime Protocol Selection Matrix

Choosing the wrong realtime transport causes server thread exhaustion, unnecessary infrastructure costs, and battery drain on mobile clients. Use this deterministic decision matrix:

| Protocol | Directionality | Transport Layer | Optimal Archetype / Use Case | When Prohibited |
| :--- | :---: | :---: | :--- | :--- |
| **Short Polling (`setInterval`)** | Client $\to$ Server | HTTP/1.1 | Temporary CLI wait scripts, throwaway testing scripts. | **STRICTLY PROHIBITED in production web apps** (destroys database connection pools). |
| **Long Polling** | Client $\to$ Server | HTTP/1.1 | Legacy browser fallback when corporate proxies terminate streaming HTTP connections. | New greenfield architectures. |
| **Server-Sent Events (SSE)** *(Solo Dev Default)* | Server $\to$ Client (Uni-directional) | Standard HTTP/2 Streaming | AI LLM completion tokens, live dashboards, order/payment status notifications, audit log streams. | Bi-directional collaborative canvas or rapid client-to-server messaging. |
| **WebSocket** | Bi-directional (Full-Duplex) | Persistent TCP Socket | Collaborative whiteboards (Fabric.js), real-time multiplayer gaming, live chat applications. | Unidirectional notification feeds (adds stateful server connection management complexity). |

---

## 2. Server-Sent Events (SSE) Engineering Standards

For single-direction server streaming (e.g. AI token generation, invoice status updates), SSE is the **mandated default**:
1. **HTTP/2 Native**: Runs over standard HTTPS (Port 443) with zero WebSocket upgrade handshakes; easily passes through corporate firewalls and Cloudflare Edge proxies.
2. **Built-in Auto-Reconnection**: The browser's native `EventSource` automatically handles network drops and reconnects with `Last-Event-ID` header resume support.
3. **Low Resource Footprint**: Does not require specialized WebSocket gateway infrastructure or sticky sessions.

```typescript
// Production SSE Handler Standard (Next.js App Router / Edge / Node.js)
export async function GET(req: Request) {
  const encoder = new TextEncoder();
  const stream = new ReadableStream({
    async start(controller) {
      // Send initial heartbeat
      controller.enqueue(encoder.encode(': heartbeat\n\n'));
      
      // Stream structured events
      const sendEvent = (event: string, data: any) => {
        controller.enqueue(encoder.encode(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`));
      };

      // Example data emission
      sendEvent('status_update', { id: 'inv-123', status: 'settled' });
      controller.close();
    }
  });

  return new Response(stream, {
    headers: {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache, no-transform',
      'Connection': 'keep-alive',
      'X-Accel-Buffering': 'no', // Disables Nginx response buffering
    },
  });
}
```

---

## 3. WebSocket Resilience Lifecycle (Heartbeats & Jittered Reconnect)

When building bi-directional tools (e.g., Fabric.js collaborative whiteboard):
* **Heartbeat Ping/Pong**: The server and client must exchange ping/pong frames every 30 seconds to detect dead TCP sockets silently closed by intermediate routers or NAT gateways.
* **Full Jitter Reconnect**: Upon disconnect, clients must reconnect using exponential backoff with randomized jitter (e.g., `delay = random(0, min(10000, 500 * 2^attempt))`) to prevent thundering herd crashes on server restart.

---

## 4. The 3-Tier Edge Architecture (Proxy vs. Gateway vs. Pooler)

Avoid conflating network ingress roles:

```text
[ Browser / Mobile Client ]
              │
              ▼ HTTPS / WSS (Port 443)
┌────────────────────────────────────────────────────────────────────────┐
│ 1. REVERSE PROXY & EDGE CDN (Cloudflare Edge / Nginx)                  │
│    • SSL Termination & Anycast DNS Routing                             │
│    • Edge WAF DDoS Filtering & Bot Mitigation                          │
│    • Static Asset Caching (Cache-Control immutable)                    │
│    • IP-based Rate Limiting (Token Bucket)                             │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ Forwarded Request
┌───────────────────────────────────▼────────────────────────────────────┐
│ 2. APPLICATION API GATEWAY (Next.js Middleware / Express / Go Router)  │
│    • Session & Authentication Validation (JWT / Supabase Auth)         │
│    • Request Body Schema Validation (Zod / Pydantic)                   │
│    • CORS & Cross-Site Request Forgery (CSRF) Enforcement              │
│    • Dynamic Route Dispatching to Services                             │
└───────────────────┬───────────────────────────────┬────────────────────┘
                    │ PostgreSQL Wire (Port 6543)    │ HTTPS REST (443)
┌───────────────────▼───────────────────────┐ ┌─────▼────────────────────┐
│ 3. DATABASE CONNECTION POOLER             │ │ 4. EXTERNAL SAAS APIs    │
│    (Supavisor / PgBouncer in Tx Mode)     │ │ • Midtrans Payments      │
│    • Reusable Transaction Slot Multiplexing│ • Resend Email            │
│    • Eliminates Serverless DB OOM Crashes │ • LLM Inference Endpoints  │
└───────────────────────────────────────────┘ └──────────────────────────┘
```

---

## 5. HTTP Semantic Status Code & Header Guardrails

* **`401 Unauthorized`**: User identity is unverified (missing or invalid token / session cookie).
* **`403 Forbidden`**: User identity is verified, but permissions / RBAC roles do not authorize access to this specific resource.
* **`429 Too Many Requests`**: Rate limit exceeded; **MUST** return `Retry-After: <seconds>` header.
* **`Idempotency-Key`**: Financial and high-risk POST mutations **MUST** require a unique UUID header to prevent double charges on network timeouts.
