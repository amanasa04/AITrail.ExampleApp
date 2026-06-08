$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$metricsPath = Join-Path $root "artifacts/performance-sample-metrics.json"
if (-not (Test-Path $metricsPath)) {
  throw "Metrics file not found: $metricsPath"
}

$payload = Get-Content -Raw -Path $metricsPath | ConvertFrom-Json

$searchP95 = [double]$payload.metrics.searchP95Seconds
$exportDuration = [double]$payload.metrics.csvExport10kSeconds
$pageLoad = [double]$payload.metrics.firstMeaningfulPageLoadSeconds

$searchMax = [double]$payload.targets.searchP95SecondsMax
$exportMax = [double]$payload.targets.csvExport10kSecondsMax
$pageLoadMax = [double]$payload.targets.firstMeaningfulPageLoadSecondsMax

$results = @(
  [PSCustomObject]@{ Metric = "searchP95Seconds"; Actual = $searchP95; Target = $searchMax; Passed = ($searchP95 -le $searchMax) },
  [PSCustomObject]@{ Metric = "csvExport10kSeconds"; Actual = $exportDuration; Target = $exportMax; Passed = ($exportDuration -le $exportMax) },
  [PSCustomObject]@{ Metric = "firstMeaningfulPageLoadSeconds"; Actual = $pageLoad; Target = $pageLoadMax; Passed = ($pageLoad -le $pageLoadMax) }
)

$reportPath = Join-Path $root "artifacts/performance-validation-report.md"
$lines = @()
$lines += "# Performance Validation Report"
$lines += ""
$lines += "| Metric | Actual | Target Max | Passed |"
$lines += "|---|---:|---:|---|"
foreach ($row in $results) {
  $lines += "| $($row.Metric) | $($row.Actual) | $($row.Target) | $($row.Passed) |"
}

$overallPass = -not ($results.Passed -contains $false)
$lines += ""
$lines += "Overall: $(if ($overallPass) { "Passed" } else { "Failed" })"

$lines | Set-Content -Path $reportPath -Encoding UTF8
Write-Host "Performance report written: $reportPath"

if (-not $overallPass) {
  exit 1
}
