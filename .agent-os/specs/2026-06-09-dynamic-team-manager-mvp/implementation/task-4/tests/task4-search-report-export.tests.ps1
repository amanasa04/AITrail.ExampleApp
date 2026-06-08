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
  "src/SearchController.cs",
  "src/ReportsController.cs",
  "src/ExportsController.cs",
  "src/QueryContracts.cs",
  "contracts/report-definitions.md",
  "contracts/csv-export-columns.md"
)

Write-Host "Running Task 4 tests..."

foreach ($relativePath in $requiredFiles) {
  $fullPath = Join-Path $root $relativePath
  Assert-True (Test-Path $fullPath) "Missing required file: $relativePath"
}

$searchController = Get-Content -Raw -Path (Join-Path $root "src/SearchController.cs")
Assert-True ($searchController -match "api/v1/search/memberships") "Search route missing"
Assert-True ($searchController -match 'Authorize\(Policy = "Search\.Read"\)') "Search policy missing"
Assert-True ($searchController -match "paging") "Search implementation should mention paging"
Assert-True ($searchController -match "sorting") "Search implementation should mention sorting"

$reportsController = Get-Content -Raw -Path (Join-Path $root "src/ReportsController.cs")
Assert-True ($reportsController -match '\[Route\("api/v1/reports"\)\]') "Reports base route missing"
Assert-True ($reportsController -match '\[HttpGet\("team-size"\)\]') "Team-size route missing"
Assert-True ($reportsController -match '\[HttpGet\("membership-trends"\)\]') "Membership-trends route missing"
Assert-True ($reportsController -match 'Authorize\(Policy = "Reports\.Read"\)') "Reports policy missing"

$exportsController = Get-Content -Raw -Path (Join-Path $root "src/ExportsController.cs")
Assert-True ($exportsController -match '\[Route\("api/v1/exports"\)\]') "Exports base route missing"
Assert-True ($exportsController -match '\[HttpGet\("memberships.csv"\)\]') "CSV export route missing"
Assert-True ($exportsController -match 'Authorize\(Policy = "Export\.Memberships"\)') "Export policy missing"
Assert-True ($exportsController -match "text/csv") "CSV content-type missing"
Assert-True ($exportsController -match "Content-Disposition") "CSV attachment header missing"

$queryContracts = Get-Content -Raw -Path (Join-Path $root "src/QueryContracts.cs")
Assert-True ($queryContracts -match "SearchMembershipsQuery") "SearchMembershipsQuery contract missing"
Assert-True ($queryContracts -match "TeamSizeReportQuery") "TeamSizeReportQuery contract missing"
Assert-True ($queryContracts -match "MembershipTrendsQuery") "MembershipTrendsQuery contract missing"

Write-Host "All Task 4 tests passed."
