# classify-scale.ps1 - Deterministic 6-Dimension Engineering Scale Classifier
param(
    [string]$ProjectState = "docs/pm/PROJECT_STATE.md"
)

if (-not (Test-Path $ProjectState)) {
    Write-Host "Error: $ProjectState not found." -ForegroundColor Red
    exit 1
}

Write-Host "=== Engineering Scale Classifier (High-Water Mark) ===" -ForegroundColor Cyan
Write-Host "Target: $ProjectState"

$tier = 1
$reason = "3-7 P0 features, isolated DB, best-effort SLA"

$p0Count = 0
if (Test-Path "docs/pm/SCOPE_STATEMENT.md") {
    $p0Count = (Select-String -Path "docs/pm/SCOPE_STATEMENT.md" -Pattern "\|.*(must|p0).*\|").Count
} elseif (Test-Path "PROJECT_LITE.md") {
    $p0Count = (Select-String -Path "PROJECT_LITE.md" -Pattern "^\s*-\s*Feature\s*[0-9]:").Count
}

Write-Host "Detected P0 Must-Have Count: $p0Count"

if ($p0Count -gt 25) {
    $tier = 4
    $reason = ">25 P0 features (Enterprise scope)"
} elseif ($p0Count -ge 16 -and $tier -lt 3) {
    $tier = 3
    $reason = "16-25 P0 features (Large Scale platform)"
} elseif ($p0Count -ge 8 -and $tier -lt 2) {
    $tier = 2
    $reason = "8-15 P0 features (Medium Scale)"
}

$content = Get-Content $ProjectState -Raw

if ($content -match "(?i)financial|rekening|saldo|pembayaran|payment|rekam medis|health|pasien|banking") {
    if ($tier -lt 2) {
        $tier = 2
        $reason = "High-Water Mark: Financial/sensitive data mutation elevates tier to Medium"
    }
}

if ($content -match "(?i)midtrans|xendit|stripe|webhook|multi-tenant") {
    if ($tier -lt 2) {
        $tier = 2
        $reason = "High-Water Mark: External payment/webhook integration elevates tier to Medium"
    }
}

if ($content -match "(?i)ojk|bank indonesia|hipaa|soc2|pci-dss") {
    $tier = 4
    $reason = "High-Water Mark: Statutory compliance (OJK/BI/HIPAA) elevates tier to Enterprise"
}

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
Write-Host "------------------------------------------------------"
