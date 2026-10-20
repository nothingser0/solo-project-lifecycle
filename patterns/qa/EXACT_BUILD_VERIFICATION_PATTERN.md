# Exact-Build Verification & Closed-Loop QA Pattern

> **Module**: M07 (Quality Assurance & SIT) & M09 (UAT & Client Sign-off)  
> **Source**: Adapted from a published autonomous agent QA coordination protocol.  
> **Objective**: Eliminate "it works on my machine" assurances and fabricated passes; enforce verifiable artifact pinning and non-binary verification lifecycles.

---

## 1. The Exact-Build Identity Rule

A QA pass or bug resolution report is **meaningless** unless bound to an immutable build artifact.

* ❌ **Unacceptable Developer Report**: *"The login bug is fixed, please test."* (Which commit? Which branch? Which environment?)
* ✅ **Standard Exact-Build Identity**:
  ```text
  Commit SHA  : c3a9f42b8e
  Artifact ID : build-20261016-0612.tar.gz (SHA256: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855)
  Environment : Staging (https://staging-api.internal:8443)
  Target Build: Node.js v20.12.0 / Next.js 15.1.0
  ```

If the build identifier cannot be pinned, testing results must be classified as **unverified working assumptions**, never formal acceptance.

---

## 2. The 4-State Verification Lifecycle

Bug fixes and acceptance criteria must never use a simplistic binary status (`Open` / `Closed`). They must transition through a disciplined 4-stage lifecycle:

```text
[ 1. Fixed in Code ] ──► [ 2. Awaiting Retest ] ──► [ 3. Verified Fixed ]
         │                                                    ▲
         │                                                    │
         └────────────────► [ 4. Deferred / Waived ] ─────────┘
```

1. **`Fixed in Code`**: The implementer commits code changes and claims resolution.
2. **`Awaiting Retest`**: A build pipeline produces an immutable artifact deployed to an isolated staging or QA test environment.
3. **`Verified Fixed`**: An independent QA pass or test script exercises the end-to-end user journey on the *exact build*, capturing tangible execution logs or screenshots.
4. **`Deferred / Waived`**: The defect is formally documented and postponed with explicit human stakeholder sign-off (recording the approver's name and business consequence).

---

## 3. The Non-Fabrication Testing Mandate

To maintain technical integrity across solo and multi-agent teams:

1. **Static Assets Cannot Verify Dynamic Flows**:
   - A successful compiler run, unit test pass, or static screenshot of a landing page CANNOT verify an interactive state transition or backend database write.
2. **End-to-End Journey Requirement**:
   - Verification must exercise the full sequence: *Input $\to$ State Mutation $\to$ Database Persistence $\to$ UI Render $\to$ Reload/Persistence Check*.
3. **Explicit Failure Documentation**:
   - If an edge case or platform (e.g., Safari iOS) cannot be tested due to lack of device tooling, it must be logged as an **Explicit Untested Gap**, never passed by assumption.
