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
$teamsPath = Join-Path $root "src/TeamsController.cs"
$membershipsPath = Join-Path $root "src/TeamMembershipsController.cs"
$auditContractsPath = Join-Path $root "src/AuditContracts.cs"
$matrixPath = Join-Path $root "contracts/endpoint-matrix.md"

Write-Host "Running Task 2 API implementation tests..."

Assert-True (Test-Path $teamsPath) "TeamsController.cs missing"
Assert-True (Test-Path $membershipsPath) "TeamMembershipsController.cs missing"
Assert-True (Test-Path $auditContractsPath) "AuditContracts.cs missing"
Assert-True (Test-Path $matrixPath) "endpoint-matrix.md missing"

$teams = Get-Content -Raw -Path $teamsPath
$memberships = Get-Content -Raw -Path $membershipsPath
$audit = Get-Content -Raw -Path $auditContractsPath

# Teams endpoints and policies
Assert-True ($teams -match '\[HttpPost\]') "TeamsController must expose POST create endpoint"
Assert-True ($teams -match '\[HttpGet\]') "TeamsController must expose GET list endpoint"
Assert-True ($teams -match '\[HttpGet\("\{teamId:long\}"\)\]') "TeamsController must expose GET by id endpoint"
Assert-True ($teams -match '\[HttpPatch\("\{teamId:long\}"\)\]') "TeamsController must expose PATCH endpoint"
Assert-True ($teams -match '\[HttpDelete\("\{teamId:long\}"\)\]') "TeamsController must expose DELETE archive endpoint"
Assert-True ($teams -match 'Authorize\(Policy = "Teams\.Write"\)') "Teams write policy missing"
Assert-True ($teams -match 'Authorize\(Policy = "Teams\.Admin"\)') "Teams admin policy missing"

# Membership endpoints and policies
Assert-True ($memberships -match 'teams/\{teamId:long\}/memberships') "Membership create/list route missing"
Assert-True ($memberships -match 'memberships/\{teamMembershipId:long\}') "Membership patch/delete route missing"
Assert-True ($memberships -match 'Authorize\(Policy = "Memberships\.Write"\)') "Membership write policy missing"
Assert-True ($memberships -match 'Authorize\(Policy = "Memberships\.Read"\)') "Membership read policy missing"

# Audit requirements on all write actions
$writeMethods = @("CreateTeam", "UpdateTeam", "ArchiveTeam", "AddMembership", "UpdateMembership", "DeleteMembership")
foreach ($methodName in $writeMethods) {
  $combined = $teams + "`n" + $memberships
  Assert-True ($combined -match "$methodName\(") "Method $methodName missing"
}

$auditWriteCount = ([regex]::Matches(($teams + "`n" + $memberships), '_auditWriter\.WriteAsync')).Count
Assert-True ($auditWriteCount -ge 6) "Each write endpoint must emit an audit event"

# Effective-date request model coverage
Assert-True ($memberships -match "EffectiveStartDate") "Membership request must include EffectiveStartDate"
Assert-True ($memberships -match "EffectiveEndDate") "Membership request must include EffectiveEndDate"

# Audit contract types
Assert-True ($audit -match "interface IAuditWriter") "IAuditWriter contract missing"
Assert-True ($audit -match "ForCreate") "ForCreate factory missing"
Assert-True ($audit -match "ForUpdate") "ForUpdate factory missing"
Assert-True ($audit -match "ForDelete") "ForDelete factory missing"

Write-Host "All Task 2 API tests passed."
