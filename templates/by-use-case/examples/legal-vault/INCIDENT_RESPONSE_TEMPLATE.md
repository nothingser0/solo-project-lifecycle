# Incident Response & Post-Mortem Report

> Root Cause Analysis (RCA) document, recovery timeline, and permanent preventive actions following an operational disruption on production servers.

---

## 1. Incident Metadata
- **Incident ID**: `INC-[YYYYMMDD]-001`
- **Severity Level**: [Severity 1 (Critical) / Severity 2 (Major)]
- **Affected Components**: [Example: Payment Gateway / PDF Rendering Vault / Database Connection]
- **Downtime Duration**: [Example: 18 Minutes]
- **Lead Incident Responder**: [Your Name]
- **Incident Date**: [YYYY-MM-DD]

---

## 2. Incident Timeline

| Time (UTC/Local) | Action Phase | Incident Description & Execution |
| :---: | :--- | :--- |
| **10:15** | **Detection (T0)** | Uptime Kuma bot triggers alert: `/api/health` endpoint returning 500 error. |
| **10:18** | **Triage (T1)** | Inspected Sentry: detected `Database connection pool timeout` caused by hanging connections. |
| **10:24** | **Mitigation (T2)** | Restarted PgBouncer pooler service and raised `connection_limit` threshold from 10 to 25. |
| **10:33** | **Recovery (T3)** | `/api/health` endpoint returned 200 OK, request queue processed normally with zero data loss. |

---

## 3. Root Cause Analysis (The 5 Whys)

1. **Why did the `/api/health` endpoint return a 500 error?**  
   *Because the backend failed to acquire an active connection to the PostgreSQL database.*
2. **Why was the database connection pool exhausted?**  
   *Because all 10 connection pool slots were saturated and held for longer than 30 seconds.*
3. **Why were connections held for so long?**  
   *Because an unindexed document search query on `form_data->>'creator_name'` triggered sequential scans across 50,000 rows.*
4. **Why was that query not indexed?**  
   *Because during initial migration, this query was assumed to run infrequently; however, client users executed concurrent filters during peak business hours.*

---

## 4. Corrective & Preventive Actions (CAPA)

| No | Corrective Action | Owner | Completion Status |
| :-: | :--- | :--- | :---: |
| 1 | Add GIN index to target JSONB column in PostgreSQL | Developer | [x] COMPLETED |
| 2 | Configure 5,000 ms query timeout across all database queries | Developer | [x] COMPLETED |
| 3 | Configure dedicated Sentry alert when connection pool reaches 80% | Developer | [x] COMPLETED |

---

## 5. Incident Report Sign-Off Sheet

This report has been reviewed jointly with the Client as a demonstration of operational transparency and continuous quality improvement commitment.

- Prepared by Lead Developer: **[Your Name]** (Date: [YYYY-MM-DD])
- Acknowledged by Client Single PIC: **[Client PIC Name]** (Date: [YYYY-MM-DD])
