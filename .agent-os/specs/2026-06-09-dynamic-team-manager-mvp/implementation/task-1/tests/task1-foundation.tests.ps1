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

function Read-Json {
  param([string]$Path)
  return Get-Content -Raw -Path $Path | ConvertFrom-Json
}

$root = Split-Path -Parent $PSScriptRoot

$sqlPath = Join-Path $root "sql/001_dynamic_team_manager_foundation.sql"
$rolePath = Join-Path $root "auth/role-policy-map.json"
$errorSchemaPath = Join-Path $root "contracts/error-envelope.schema.json"
$contractPath = Join-Path $root "contracts/request-correlation-and-audit.md"

Write-Host "Running Task 1 foundation tests..."

# 1. SQL migration file existence and required table definitions.
Assert-True (Test-Path $sqlPath) "SQL migration file is missing"
$sqlText = Get-Content -Raw -Path $sqlPath
Assert-True ($sqlText -match "CREATE TABLE dbo\.Employees") "Employees table missing in migration"
Assert-True ($sqlText -match "CREATE TABLE dbo\.Teams") "Teams table missing in migration"
Assert-True ($sqlText -match "CREATE TABLE dbo\.TeamMemberships") "TeamMemberships table missing in migration"
Assert-True ($sqlText -match "CREATE TABLE dbo\.AuditLogs") "AuditLogs table missing in migration"
Assert-True ($sqlText -match "CK_TeamMemberships_DateRange") "Membership date-range constraint missing"

# 2. Role mapping contracts and required roles.
Assert-True (Test-Path $rolePath) "Role policy map file is missing"
$roleMap = Read-Json -Path $rolePath
$roleNames = @($roleMap.application_roles | ForEach-Object { $_.name })
@("Employee", "TeamEditor", "HRAnalyst", "Admin") | ForEach-Object {
  Assert-True ($roleNames -contains $_) "Missing application role: $_"
}

# 3. Error envelope schema requirements.
Assert-True (Test-Path $errorSchemaPath) "Error envelope schema file is missing"
$errorSchema = Read-Json -Path $errorSchemaPath
$required = @($errorSchema.required)
@("code", "message", "correlationId") | ForEach-Object {
  Assert-True ($required -contains $_) "Error envelope must require property: $_"
}

# 4. Correlation and audit middleware contract presence.
Assert-True (Test-Path $contractPath) "Correlation/audit contract markdown is missing"
$contractText = Get-Content -Raw -Path $contractPath
Assert-True ($contractText -match "X-Correlation-Id") "Correlation header contract missing"
Assert-True ($contractText -match "Audit Logging Behavior") "Audit logging section missing"

Write-Host "All Task 1 foundation tests passed."
