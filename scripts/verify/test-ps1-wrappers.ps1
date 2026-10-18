# Manual verification harness (not part of CI): parse-checks the PowerShell wrappers
# and proves validate-gate.ps1 resolves the CALLER's project, not the framework repo.
$ErrorActionPreference = 'Stop'
$fail = 0

Write-Host "=== 1. PSParser tokenization ==="
foreach ($f in @(
    'scripts/gates/validate-gate.ps1',
    'scripts/gates/lib/BashResolver.ps1',
    'scripts/gates/classify-scale.ps1'
)) {
    $errors = $null
    $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $f -Raw), [ref]$errors)
    if ($errors.Count -gt 0) {
        Write-Host ("  [FAIL] {0}: {1} error(s)" -f $f, $errors.Count)
        $fail++
    } else {
        Write-Host ("  [PASS] {0}" -f $f)
    }
}

Write-Host ""
Write-Host "=== 2. Wrapper resolves the caller's project (regression: v2.2 cd'd to repo root) ==="
$proj = Join-Path $env:TEMP "m00-ps1-probe"
Remove-Item -Recurse -Force $proj -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path (Join-Path $proj "docs/pm") | Out-Null
[System.IO.File]::WriteAllText((Join-Path $proj "docs/pm/PROJECT_STATE.md"),
    "- **Scale**: Medium`n- Delivery: solo`n", [System.Text.Encoding]::UTF8)

# The fixture must carry the gate's real evidence markers, but this FILE has to stay
# pure ASCII: Windows PowerShell 5.1 decodes BOM-less scripts as the ANSI codepage,
# where a raw UTF-8 checkmark becomes mojibake and breaks parsing. Emit it at runtime.
$check = [char]0x2705

$doc = @"
# M00-Lite: Rapid Market Validation

## 2. Riskiest Assumption Register (RAT)

| ID | Core Hypothesis | Risk Level | Evidence Needed | Cheap Test Method | Kill Threshold | Outcome |
|:---|:---|:---:|:---|:---|:---|:---:|
| **ASM-01** | Users lose money monthly | HIGH | 3/5 confirm | Interviews | <2 | [x] |

## 3. Quick Competitor & Alternative Check

| Solution Name | Type | Price / Tier | Strengths | Critical Weaknesses | Unique Differentiator We Offer |
|:---|:---|:---|:---|:---|:---|
| Competitor X | SaaS | Rp 200k/mo | Brand | Offline broken | Offline-first |

## 4. Qualitative User Discovery (5 User Interviews)

| Respondent ID | Role | Current Solution | Friction | Willingness to Pay | Evidence Status |
|:---|:---|:---|:---|:---|:---:|
| **INT-01** | Grocery | paper | loss | Rp 50k | $check Real |
| **INT-02** | Pet shop | Excel | corrupt | Rp 100k | $check Real |
| **INT-03** | Boutique | POS X | slow | Rp 150k | $check Real |

## 5. Behavioral Intent Validation (Waitlist / Smoke Test)

- **Total Unique Visitors**: 120
- **Total Waitlist / Email Signups**: 9
- **Waitlist-Conversion-Pct**: 7.5

## 6. Unit Economics & Pricing Feasibility

- **Acquisition Cost (CAC)**: Rp 15,000 / user
- **Lifetime Value (LTV)**: Rp 900,000 / user
- **LTV / CAC Ratio**: 60x
- **Gross Margin**: 85%

Validated-by: Test Lead on 2026-10-11

## 7. Kill Criteria & Gate Validation Outcome

Gate-Decision: PASS
"@
[System.IO.File]::WriteAllText((Join-Path $proj "docs/pm/M00_LITE.md"), $doc, [System.Text.Encoding]::UTF8)

$wrapper = Join-Path (Split-Path -Parent $PSScriptRoot) "gates/validate-gate.ps1"
Push-Location $proj
try {
    $out = & $wrapper M00 2>&1 | Out-String
    $code = $LASTEXITCODE
} finally {
    Pop-Location
}
Write-Host $out
if ($code -eq 0 -and $out -match 'solo capacity|Validated-by|Gate validation PASSED') {
    Write-Host "  [PASS] wrapper validated the CALLER's project (exit 0)"
} elseif ($out -match 'no usable bash|No usable bash') {
    Write-Host "  [WARN] no usable bash in this environment; cwd path untested"
} else {
    Write-Host ("  [FAIL] expected exit 0 from the caller's project, got {0}" -f $code)
    $fail++
}

Write-Host ""
if ($fail -eq 0) { Write-Host "ALL PS1 CHECKS PASSED"; exit 0 }
Write-Host ("{0} CHECK(S) FAILED" -f $fail)
exit 1
