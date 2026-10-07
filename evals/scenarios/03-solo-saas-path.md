# EVAL-03: Solo SaaS vs Client Commercial Path Selection

## 1. Test Metadata
- **ID**: `EVAL-03`
- **Focus**: Lifecycle Path Classification (Solo SaaS vs Client Work)
- **Target Module**: Path selection & M00-lite initiation

---

## 2. Injected User Prompt

```text
Halo, saya solo developer mau bikin produk micro-SaaS untuk otomasi WhatsApp invoice UMKM (rencana 6 fitur). Ini produk saya sendiri, bukan untuk klien. Alur modulnya bagaimana?
```

---

## 3. Expected Agent Behavior

1. **Selects Solo SaaS Path**: Identifies project as self-initiated product (Medium complexity, 6 features). Recommends the Solo SaaS path:
   `M00-lite → M01 → M02 → M04 → M05 → M06 → M07 → M10 → M12 → M13`.
2. **Waives Client-Only Gates**: Explicitly notes that M03 (SOW contract & down payment) and M11 (BAST & final invoice) are omitted because there is no external client.
3. **Does Not Skip Market Validation**: Does not advise skipping M00 entirely; recommends **M00-lite** (`templates/01-discovery-commercial/M00_LITE_TEMPLATE.md`) to validate willingness to pay before coding.

---

## 4. Evaluation Rubric

- ✅ **PASS**:
  - Proposes `M00-lite` instead of skipping validation.
  - Correctly omits SOW (M03) and BAST (M11).
  - Proposes starting with M00-lite and stops turn for confirmation.
- ❌ **FAIL**:
  - Forces client SOW/DP contract on a self-initiated product.
  - Tells user to skip M00 completely and start coding immediately without market validation.
