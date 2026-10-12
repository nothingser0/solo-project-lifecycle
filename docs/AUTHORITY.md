# AUTHORITY.md — Who Does What (Agent vs Human)

> **Status**: single source of truth for role attribution in this framework.
> Referenced from `SKILL.md`. Read this before assigning any activity to the agent.
>
> **Why this file exists**: the framework used to imply roles through phrasing. The
> result was predictable — agents ticked their own boxes, signed their own design
> freezes, deployed to production, and ran whole sprints unattended. Role attribution
> is now explicit and, where possible, gate-enforced.

---

## 1. The four classes

| Class | Meaning | Enforcement |
| :--- | :--- | :--- |
| **AGENT** | The agent produces the artefact end-to-end: writes documents, drafts specs, generates code, runs scripts, computes numbers. | n/a |
| **HUMAN DECIDES** | The agent drafts 2–3 options; the **human chooses**. The agent must END TURN and wait. | prose + some gates |
| **HUMAN ONLY** | Physically or legally outside agent capability: signatures, money, real people, credentials custody, legal review. | prose (unverifiable by design) |
| **FORBIDDEN** | The agent must **never** do this, even if asked casually. | gate + `AGENTS.md` |

**The dividing line is signature, money, real people, and access** — not effort.

---

## 2. Per-module attribution

### M00 — Product Discovery
| Agent | Human decides | Human only |
|---|---|---|
| Market/competitor research, TAM/SAM/SOM **with cited sources**, unit economics, GTM draft | — | **5–10 real user interviews** (`00:47`), 30–50 surveys, waitlist, **refundable deposits / signed LOIs** |

> 🧑 Marked `HUMAN-ONLY` inline: the agent cannot verify interviews happened. It records `PENDING_PRIMARY_RESEARCH` and ends the turn.

### M01 — Idea Feasibility
| Agent | Human decides |
|---|---|
| 4D scorecard, risk register, roadmap, RICE, archetype classification | **GO / CONDITIONAL_GO / PIVOT / KILL** (`01:49`) |

### M02 — Discovery & Scope
| Agent | Human only |
|---|---|
| NSM, MoSCoW, permission tables, schema rules, effort formula | **Discovery Interview** (5 Pillars), 50–100 signups, **sandbox keys / email credentials / master data** |

> ⚠️ Open item: `02:38-39` lets the agent draft Privacy Policy / ToS / tax disclaimers with
> no counsel-review gate, unlike M03 and A00.

### M03 — Legal / SOW / DP 〔GATE〕
| Agent | Human only |
|---|---|
| SOW **draft**, payment-matching logic, CR sheet | **Contract signature** (`03:65`), **DP received in bank** (`03:67`), professional legal review (`03:5`) |

### M04 — UI/UX & Prototype
| Agent | Human decides | Human only |
|---|---|---|
| Sitemap, component requirements, `DESIGN.md` tokens + WCAG, screen spec, AI prompts | Prototyping workflow A–E (`04:20`), design approval (`04:70`) | **Design Freeze sign-off** (`04:58`), real brand assets |

> ✅ **Gate-enforced**: `validate-gate.sh M04` fails if the freeze has no named approver, no real date, or residual `_____` blank fields.

### M05 — Architecture & Specs 〔STACK LOCK〕
| Agent | Human decides |
|---|---|
| 2–3 stack options + cost/pros/cons, DDL, API matrix, PRD/FSD | **Answer the 8 questions** (`05:37`), **LOCK the stack** (`05:40`), FSD sign-off (`05:71`) |

> ✅ **Gate-enforced**: `validate-gate.sh M05` fails if `Stack Decision LOCKED:` appears without the 8 recorded answers. Applies to **both** paths (Small previously skipped this check entirely).

### M06 — Development
| Agent | Human |
|---|---|
| Implement **ONE task per turn** → run its `Verify` → report Evidence → 🛑 END TURN | **Approve each task**, merge to `staging`, tag Alpha |

> ✅ **Gate-enforced**: `validate-gate.sh M06` fails on any `[x]` task whose Evidence lacks `Approved: <date> by <name>`.

### M07 — QA & SIT
| Agent | Human only |
|---|---|
| Tests, OWASP, load test, SIT workbook, polish audit rows | **Approval to proceed** (`07:90`), **real-phone pass** (`07:63`), third-party pentest (`07:44`) |

> 🧑 Marked `HUMAN-ONLY` inline: the real-device pass.

### M08 — Data Migration
| Agent | Human only |
|---|---|
| Audit, mapping matrix, PII masking, ETL script, reconciliation | **Client agrees the mapping** (`08:14`), `rejected-rows.csv` → client ops, **Data Sign-Off** (`08:18`) |

> ✅ **Gate-enforced**: `validate-gate.sh M08` requires an `Inputs-Received:` record — the client's source data and credentials are never invented or simulated.

### M09 — UAT 〔GATE〕
| Agent | Human only |
|---|---|
| Test steps, tester accounts, triage, fix bugs on `fix/*` | **Client PIC tests and signs** (`09:6`, `09:18`), Deemed Acceptance call (`09:26`), go-live authorisation (`09:77`) |

### M10 — Deployment
| Agent | Human only |
|---|---|
| Build, snapshot, verification, protocol documents | **🚫 The deploy itself** (`10:14` "no agent auto-deploy"), Go/No-Go, DNS pointing, **real Rp-10.000 production payment** (`10:37`), invoice (`10:79`) |

> ✅ **Gate-enforced**: `Inputs-Received:` record for production access.

### M11 — Handover / BAST 〔GATE〕
| Agent | Human only |
|---|---|
| `USER_MANUAL.md`, handover inventory, BAST **draft** | **🚫 Repo transfer, root credentials, BAST signature** (`11:6`), bank confirmation (`11:15`), training delivery |

### M12 — Warranty / SLA
| Agent | Human only |
|---|---|
| Triage, hotfix code on `fix/*`, post-mortem | Incident comms (`12:37`), warranty voidness, retainer tier, contract signature (`12:56`), **merge `main` + tag** (`12:38`) |

### M13 — Product Operations
| Agent | Human only |
|---|---|
| Metrics, cohorts, RICE, experiment hypotheses | **Double Down / Pivot / Kill** (`13:38`), recruiting power users (`13:35`), NPS to real users (`13:34`) |

### A00 — Enterprise Advisory
| Agent | Human only |
|---|---|
| Architecture drafts, ADR, STRIDE, blueprints | 🛑 **3 STOPs**: Advisory Agreement, Arch Sign-off, Final Sign-off — **mandatory legal counsel** (`A00:55`) |

---

## 3. Global FORBIDDEN list (any scale)

1. **Never sign or self-approve anything.** Design Freeze, FSD sign-off, UAT, BAST, task `[x]`. An approver is always a human name.
2. **Never commit, push, or tag.** Hand changes over for human review. Pushing to `main` is a production deploy.
3. **Never deploy to production.** M10 reserves it to the human.
4. **Never hold or use production credentials,** or transfer repo/root access (M11 "No Pay, No Root").
5. **Never state or imply a payment was received.** DP confirmation comes from the human's bank statement.
6. **Never fabricate primary research.** No invented interviews, quotes, percentages, or signups.
7. **Never invent client inputs.** Source data, credentials, and master data are received, not simulated.
8. **Never take a business decision:** pricing, kill/pivot, stack choice, scope changes without a CR.
9. **Never contact the client or end users** on its own initiative (email, chat, personal numbers).
10. **Never accept "Deemed Acceptance"** or assert its legal consequence.

---

## 4. What is actually enforced

| Check | Where | Status |
| :--- | :--- | :--- |
| 5 intake questions answered | `validate-gate.sh` M01/M02/M04/M05/M06 | ✅ script |
| Per-task human approval | `validate-gate.sh` M06 | ✅ script |
| Design Freeze signed | `validate-gate.sh` M04 | ✅ script |
| 8 questionnaire answers recorded | `validate-gate.sh` M05 | ✅ script |
| Client inputs received | `validate-gate.sh` M08/M10 | ✅ script |
| Blank signature lines rejected | `validate-gate.sh` M08/M09/M11 | ✅ script |
| Real-phone pass performed | — | 🧑 prose only |
| Interviews actually happened | — | 🧑 prose only (unverifiable) |
| Agent stopped when it should have | — | 🧑 prose only |

**Honest limit**: gate-time enforcement blocks a *wrong declaration*. It cannot
interrupt an agent mid-turn. The [`AGENTS.md` harness](../templates/04-dev-execution/) carries the
one-task-per-turn protocol into the project itself, which is the strongest available
lever without a runtime hook.

---

## 5. Related

- `../SKILL.md` rule 3 — stop points and the M06 per-task loop
- `../templates/04-dev-execution/TODO_TEMPLATE.md` — approval-marker format
- `../scripts/gates/validate-gate.sh` — the executable enforcement
- `../scripts/verify/test-gate-regressions.sh` — regression guards for each check above
