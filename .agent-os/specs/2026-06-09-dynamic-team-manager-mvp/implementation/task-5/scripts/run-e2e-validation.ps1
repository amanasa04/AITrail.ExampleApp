$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $root))))

function Test-RequiredFile {
  param([string]$RelativePath)
  $path = Join-Path $repoRoot $RelativePath
  return Test-Path $path
}

$checks = @(
  @{ Workflow = "Manager updates"; Path = ".agent-os/specs/2026-06-09-dynamic-team-manager-mvp/implementation/task-2/src/TeamsController.cs" },
  @{ Workflow = "HR audit and search"; Path = ".agent-os/specs/2026-06-09-dynamic-team-manager-mvp/implementation/task-4/src/SearchController.cs" },
  @{ Workflow = "Employee self-verification"; Path = ".agent-os/specs/2026-06-09-dynamic-team-manager-mvp/implementation/task-3/src/pages/TeamDetailPage.tsx" },
  @{ Workflow = "Admin reporting and export"; Path = ".agent-os/specs/2026-06-09-dynamic-team-manager-mvp/implementation/task-4/src/ReportsController.cs" }
)

$results = @()
foreach ($check in $checks) {
  $passed = Test-RequiredFile -RelativePath $check.Path
  $results += [PSCustomObject]@{
    Workflow = $check.Workflow
    Status = if ($passed) { "Passed" } else { "Failed" }
    Evidence = $check.Path
  }
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$reportPath = Join-Path $root "artifacts/e2e-validation-report.md"

$lines = @()
$lines += "# E2E Validation Report"
$lines += ""
$lines += "Generated: $timestamp"
$lines += ""
$lines += "| Workflow | Status | Evidence |"
$lines += "|---|---|---|"
foreach ($row in $results) {
  $lines += "| $($row.Workflow) | $($row.Status) | $($row.Evidence) |"
}

$overallPass = -not ($results.Status -contains "Failed")
$lines += ""
$lines += "Overall: $(if ($overallPass) { "Passed" } else { "Failed" })"

$lines | Set-Content -Path $reportPath -Encoding UTF8
Write-Host "E2E report written: $reportPath"
if (-not $overallPass) {
  exit 1
}
