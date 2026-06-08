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
$files = @(
  "src/types.ts",
  "src/api/client.ts",
  "src/api/teams.ts",
  "src/pages/TeamListPage.tsx",
  "src/pages/TeamDetailPage.tsx",
  "src/components/MembershipEditorDialog.tsx"
)

Write-Host "Running Task 3 frontend tests..."

foreach ($file in $files) {
  $path = Join-Path $root $file
  Assert-True (Test-Path $path) "Missing required file: $file"
}

$teamsApi = Get-Content -Raw -Path (Join-Path $root "src/api/teams.ts")
Assert-True ($teamsApi -match 'useQuery') "teams.ts must include useQuery hooks"
Assert-True ($teamsApi -match 'useMutation') "teams.ts must include useMutation hooks"
Assert-True ($teamsApi -match 'useTeams') "teams.ts must expose useTeams"
Assert-True ($teamsApi -match 'useTeamMemberships') "teams.ts must expose useTeamMemberships"

$teamList = Get-Content -Raw -Path (Join-Path $root "src/pages/TeamListPage.tsx")
Assert-True ($teamList -match 'Team List') "TeamListPage must render Team List heading"
Assert-True ($teamList -match 'Create Team') "TeamListPage must include create action"
Assert-True ($teamList -match 'rename') "TeamListPage must include rename behavior"
Assert-True ($teamList -match 'archive') "TeamListPage must include archive behavior"

$teamDetail = Get-Content -Raw -Path (Join-Path $root "src/pages/TeamDetailPage.tsx")
Assert-True ($teamDetail -match 'Roster') "TeamDetailPage must include roster section"
Assert-True ($teamDetail -match 'role') "TeamDetailPage must include role filtering"
Assert-True ($teamDetail -match 'active') "TeamDetailPage must include active filter"

$membershipEditor = Get-Content -Raw -Path (Join-Path $root "src/components/MembershipEditorDialog.tsx")
Assert-True ($membershipEditor -match 'employee') "Membership editor must include employee lookup"
Assert-True ($membershipEditor -match 'teamRole') "Membership editor must include teamRole field"
Assert-True ($membershipEditor -match 'effectiveStartDate') "Membership editor must include effectiveStartDate field"
Assert-True ($membershipEditor -match 'effectiveEndDate') "Membership editor must include effectiveEndDate field"

Write-Host "All Task 3 frontend tests passed."
