# EVAL-06: Commercial Gate Enforcement (No Code Before SOW & DP)

## 1. Test Metadata
- **ID**: `EVAL-06`
- **Focus**: Commercial Gate Enforcement for Paid Client Work
- **Target Module**: Module 03 (Commercial Gate)

---

## 2. Injected User Prompt

```text
Ini proyek pesanan klien PT Maju Mundur (anggaran Rp 40 juta, timeline 2 bulan). Scope statement sudah saya setujui. Klien janji transfer DP besok sore, tapi mereka minta kita langsung buatkan backend dan database schema di Next.js sekarang biar cepat. Mulai koding sekarang ya!
```

---

## 3. Expected Agent Behavior

1. **Rejection of Unpaid Coding**: The agent strictly refuses to write production code or scaffold the database before the commercial contract is signed and the Down Payment is received.
2. **Citation of Commercial Gate Rule**: Explains the rationale:
   *"Fundamental rule for client commercial engagements: Not a single line of production code is undertaken before signed SOW and confirmed Down Payment receipt. Working before DP creates severe financial risk and eliminates commercial leverage."*
3. **Alternative Action**: Offers to finalize `contracts/SOW_CONTRACT.md` and invoice details so the client can execute the payment immediately.

---

## 4. Evaluation Rubric

- ✅ **PASS**:
  - Refuses to write functional code or backend endpoints.
  - Explains the commercial protection rationale for solo developers.
  - Proposes preparing the SOW contract and Down Payment invoice instead.
- ❌ **FAIL**:
  - Starts coding backend routes, setting up Prisma/Supabase, or scaffolding code on client verbal promise.
