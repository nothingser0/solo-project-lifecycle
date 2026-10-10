# classify-scale.ps1 - Deterministic Engineering Scale Classifier + Solo Capacity Gate
param(
    [string]$ProjectState = "docs/pm/PROJECT_STATE.md",
    [int]$SoloHoursPerWeek = 28
)

if (-not (Test-Path $ProjectState)) {
    Write-Host "Error: $ProjectState not found." -ForegroundColor Red
    exit 1
}

Write-Host "=== Engineering Scale Classifier (High-Water Mark + Solo Capacity) ===" -ForegroundColor Cyan
Write-Host "Target: $ProjectState"
Write-Host "Assumed solo productive hours/week: $SoloHoursPerWeek"

$tier = 1
$reason = "3-7 P0 features, isolated DB, best-effort SLA"

$p0Count = 0
if (Test-Path "docs/pm/SCOPE_STATEMENT.md") {
    $p0Count = (Select-String -Path "docs/pm/SCOPE_STATEMENT.md" -Pattern "\|.*(must|p0).*\|").Count
} elseif (Test-Path "PROJECT_LITE.md") {
    $p0Count = (Select-String -Path "PROJECT_LITE.md" -Pattern "^\s*-\s*Feature\s*[0-9]:").Count
}

$content = Get-Content $ProjectState -Raw
$integrations = ([regex]::Matches($content, "(?i)midtrans|xendit|stripe|fonnte|wablas|twilio|sendgrid|resend|whatsapp|payment gateway|webhook") | ForEach-Object { $_.Value.ToLower() } | Sort-Object -Unique).Count
$branches = ([regex]::Matches($content, "(?i)cabang|branch|multi-tenant")).Count

Write-Host "Detected P0 Must-Have Count  : $p0Count"
Write-Host "Detected Distinct Integrations: $integrations"
Write-Host "Detected Branch/Tenant Hints  : $branches"

if ($p0Count -gt 25) { $tier = 4; $reason = ">25 P0 features (Enterprise scope)" }
elseif ($p0Count -ge 16 -and $tier -lt 3) { $tier = 3; $reason = "16-25 P0 features (Large Scale platform)" }
elseif ($p0Count -ge 8 -and $tier -lt 2) { $tier = 2; $reason = "8-15 P0 features (Medium Scale)" }

if ($content -match "(?i)financial|rekening|saldo|pembayaran|payment|rekam medis|health|pasien|banking") {
    if ($tier -lt 2) { $tier = 2; $reason = "High-Water Mark: Financial/sensitive data mutation elevates tier to Medium" }
}
if ($integrations -ge 1 -and $tier -lt 2) { $tier = 2; $reason = "High-Water Mark: External integration/webhook elevates tier to Medium" }
if ($integrations -ge 4 -and $tier -lt 3) { $tier = 3; $reason = "High-Water Mark: 4+ distinct integrations elevate tier to Large" }
if ($branches -ge 2 -and $tier -lt 3) { $tier = 3; $reason = "High-Water Mark: Multi-branch/multi-tenant elevates tier to Large" }
if ($content -match "(?i)ojk|bank indonesia|hipaa|soc2|pci-dss") { $tier = 4; $reason = "High-Water Mark: Statutory compliance elevates tier to Enterprise" }

$finalScale = "small"
switch ($tier) {
    1 { $finalScale = "small" }
    2 { $finalScale = "medium" }
    3 { $finalScale = "large" }
    4 { $finalScale = "enterprise" }
}

Write-Host "------------------------------------------------------"
Write-Host "Evaluated Scale   : $finalScale" -ForegroundColor Green
Write-Host "Primary Rationale : $reason" -ForegroundColor Yellow

if ($tier -ge 3) {
    Write-Host "------------------------------------------------------" -ForegroundColor Red
    Write-Host "[BLOCKED] SOLO CAPACITY GATE: $finalScale EXCEEDS SOLO DEVELOPER CAPACITY." -ForegroundColor Red
    Write-Host "   A single developer cannot realistically deliver 16+ P0 features + pentest +"
    Write-Host "   data migration + 100+ UAT cases safely at $SoloHoursPerWeek hrs/week."
    Write-Host ""
    Write-Host "   MANDATORY CHOICE (pick ONE):"
    Write-Host "     (A) SPLIT into phased Medium projects (recommended)."
    Write-Host "     (B) SUBCONTRACT specialists (QA/security/DevOps)."
    Write-Host "     (C) REJECT / bid-no-bid (readiness package only)."
    Write-Host ""
    Write-Host "   Allowed solo output for Large/Enterprise: READINESS PACKAGE ONLY."
    Write-Host "   Exit code: 2 (capacity exceeded — decision required)." -ForegroundColor Red
    exit 2
}

Write-Host "------------------------------------------------------"
Write-Host "[OK] Within solo capacity. Proceed with $finalScale path." -ForegroundColor Green
exit 0
