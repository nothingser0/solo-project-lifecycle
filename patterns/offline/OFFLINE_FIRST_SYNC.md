# Offline-First & Data Synchronization Pattern

> **Target**: Retail POS, field data collection, warehouse inventory, and mobile apps operating under unstable Indonesian network conditions (intermittent 4G, cellular dead zones).

---

## 1. Core Synchronization Architecture

```
[ User Interaction ] ──► [ Local Database (IndexedDB / SQLite) ] ──► [ UI Renders Instantly ]
                                     │
                             (Mutation Queue)
                                     ▼
                      [ Background Sync Worker ]
                                     │
                     ┌───────────────┴───────────────┐
                     ▼                               ▼
             [ Device Online ]               [ Device Offline ]
                     │                               │
        [ POST /api/v1/sync/batch ]       [ Queue Persists Locally ]
                     │                               │
        [ Conflict Resolution Engine ]    [ Wait for 'online' Event ]
                     │
        [ Acknowledge & Prune Queue ]
```

---

## 2. Local Mutation Queue Schema (TypeScript / IndexedDB)

```typescript
export interface QueuedMutation {
  id: string; // UUIDv7 (time-sortable)
  entity: 'order' | 'inventory_item' | 'customer';
  action: 'CREATE' | 'UPDATE' | 'DELETE';
  payload: Record<string, unknown>;
  clientTimestamp: number;
  retryCount: number;
  syncStatus: 'PENDING' | 'SYNCING' | 'FAILED';
  errorMessage?: string;
}
```

---

## 3. Optimistic Mutation Execution

```typescript
import { openDB } from 'idb';

const dbPromise = openDB('app-local-db', 1, {
  upgrade(db) {
    db.createObjectStore('orders', { keyPath: 'id' });
    const queue = db.createObjectStore('sync_queue', { keyPath: 'id' });
    queue.createIndex('by_status', 'syncStatus');
  },
});

export async function createOrderOfflineFirst(orderData: { id: string; total: number; items: unknown[] }) {
  const db = await dbPromise;

  const mutation: QueuedMutation = {
    id: crypto.randomUUID(),
    entity: 'order',
    action: 'CREATE',
    payload: orderData,
    clientTimestamp: Date.now(),
    retryCount: 0,
    syncStatus: 'PENDING',
  };

  // 1. Write to both local cache and sync queue in a single transaction
  const tx = db.transaction(['orders', 'sync_queue'], 'readwrite');
  await tx.objectStore('orders').put({ ...orderData, isLocalOnly: true });
  await tx.objectStore('sync_queue').put(mutation);
  await tx.done;

  // 2. Trigger non-blocking background sync attempt
  if (navigator.onLine) {
    triggerBackgroundSync();
  }

  return { success: true, localId: orderData.id };
}
```

---

## 4. Conflict Resolution Strategies

1. **Last-Write-Wins (LWW)**:
   - Suitable for simple profile edits and status changes.
   - Compare `clientTimestamp` against database `updated_at`. The newest record prevails.
2. **Delta / Accumulator Merging (Financial & Stock Balances)**:
   - **Never overwrite raw inventory balances from client state** (e.g., `stock = 10`).
   - Send atomic deltas instead: `stock_delta = -2`. Database executes:
     ```sql
     UPDATE products SET stock = stock - 2, updated_at = NOW() WHERE id = $1;
     ```
3. **Supervisor Review Drawer (Domain Exceptions)**:
   - If stock decrement causes the database balance to drop below zero (due to concurrent purchases at another branch), the transaction is flagged for manager review rather than failing customer checkout silently.
