$ErrorActionPreference = "Stop"

function Assert-True {
  param(
    [bool]$Condition,
    [string]$Message
  )

  if (-not $Condition) {
    throw "ASSERT FAILED: $Message"
  }
}

$root = Split-Path -Parent $PSScriptRoot

$requiredFiles = @(
  "docs/non-functional-test-scenarios.md",
  "docs/runbook.md",
  "docs/deployment-checklist.md",
  "scripts/run-e2e-validation.ps1",
  "scripts/validate-performance-targets.ps1",
  "artifacts/performance-sample-metrics.json",
  "artifacts/e2e-validation-report.md",
  "artifacts/performance-validation-report.md"
)

Write-Host "Running Task 5 release readiness tests..."

foreach ($relative in $requiredFiles) {
  Assert-True (Test-Path (Join-Path $root $relative)) "Missing required release artifact: $relative"
}

$scenarios = Get-Content -Raw -Path (Join-Path $root "docs/non-functional-test-scenarios.md")
Assert-True ($scenarios -match "P95") "Non-functional scenarios must include P95 criteria"
Assert-True ($scenarios -match "30 seconds") "Non-functional scenarios must include CSV export throughput target"

$runbook = Get-Content -Raw -Path (Join-Path $root "docs/runbook.md")
Assert-True ($runbook -match "correlation id") "Runbook must include correlation-id triage guidance"
Assert-True ($runbook -match "Rollback") "Runbook must include rollback guidance"

$deploy = Get-Content -Raw -Path (Join-Path $root "docs/deployment-checklist.md")
Assert-True ($deploy -match "Pre-deploy") "Deployment checklist must include pre-deploy stage"
Assert-True ($deploy -match "Promote to production") "Deployment checklist must include production promotion stage"

$e2eReport = Get-Content -Raw -Path (Join-Path $root "artifacts/e2e-validation-report.md")
Assert-True ($e2eReport -match "Overall: Passed") "E2E report must pass"

$perfReport = Get-Content -Raw -Path (Join-Path $root "artifacts/performance-validation-report.md")
Assert-True ($perfReport -match "Overall: Passed") "Performance report must pass"

Write-Host "All Task 5 tests passed."
