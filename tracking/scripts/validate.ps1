$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$trackingDir = Resolve-Path (Join-Path $scriptDir "..")
$schemaDir = Join-Path $trackingDir "schema"
$rubricPath = Join-Path $trackingDir "rubric/rubric.v1.json"
$progressDir = Join-Path $trackingDir "progress"
$reviewEventsPath = Join-Path $trackingDir "events/review-events.jsonl"
$promotionEventsPath = Join-Path $trackingDir "events/promotion-events.jsonl"

$errors = New-Object System.Collections.Generic.List[string]

function Add-ValidationError {
    param([string]$Message)
    $errors.Add($Message) | Out-Null
}

function Has-RequiredProperties {
    param(
        [object]$Object,
        [string[]]$RequiredProperties
    )

    foreach ($prop in $RequiredProperties) {
        if (-not ($Object.PSObject.Properties.Name -contains $prop)) {
            return $false
        }
    }
    return $true
}

function Validate-JsonFile {
    param(
        [string]$JsonPath,
        [string]$Label
    )

    try {
        $obj = Get-Content -Raw -Path $JsonPath | ConvertFrom-Json

        switch ($Label) {
            "Rubric" {
                $required = @("rubric_id", "name", "version", "effective_from", "status", "levels")
                if (-not (Has-RequiredProperties -Object $obj -RequiredProperties $required)) {
                    Add-ValidationError "Rubric validation failed: missing required top-level fields in $JsonPath"
                }
            }
            "Progress" {
                $required = @("progress_id", "user_id", "user_name", "team", "rubric_id", "rubric_version", "current_level_id", "target_level_id", "readiness_state", "criterion_status", "evidence")
                if (-not (Has-RequiredProperties -Object $obj -RequiredProperties $required)) {
                    Add-ValidationError "Progress validation failed: missing required top-level fields in $JsonPath"
                }
            }
        }
    }
    catch {
        Add-ValidationError "$Label validation failed: $JsonPath. $($_.Exception.Message)"
    }
}

function Read-Jsonl {
    param([string]$Path)

    $items = @()
    if (-not (Test-Path $Path)) {
        return $items
    }

    $lines = Get-Content -Path $Path
    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        try {
            $items += ($line | ConvertFrom-Json)
        }
        catch {
            Add-ValidationError "Invalid JSONL line in ${Path}: $line"
        }
    }

    return $items
}

# Schema validation
Validate-JsonFile -JsonPath $rubricPath -Label "Rubric"

$progressFiles = Get-ChildItem -Path $progressDir -Filter "*.json" -File -ErrorAction SilentlyContinue
foreach ($file in $progressFiles) {
    Validate-JsonFile -JsonPath $file.FullName -Label "Progress"
}

$reviewEvents = Read-Jsonl -Path $reviewEventsPath
$promotionEvents = Read-Jsonl -Path $promotionEventsPath

foreach ($event in $reviewEvents) {
    $required = @("event_id", "event_type", "progress_id", "criterion_id", "reviewer_id", "decision", "comment", "decided_at")
    if (-not (Has-RequiredProperties -Object $event -RequiredProperties $required)) {
        Add-ValidationError "Review event failed validation: missing required fields for event $($event.event_id)."
    }
}

foreach ($event in $promotionEvents) {
    $required = @("event_id", "event_type", "progress_id", "from_level_id", "to_level_id", "approver_id", "reason", "decided_at")
    if (-not (Has-RequiredProperties -Object $event -RequiredProperties $required)) {
        Add-ValidationError "Promotion event failed validation: missing required fields for event $($event.event_id)."
    }
}

# Workflow validation helpers
$rubric = Get-Content -Raw -Path $rubricPath | ConvertFrom-Json
$levelSequence = @{}
$requiredCriteriaByLevel = @{}
foreach ($lvl in $rubric.levels) {
    $levelSequence[$lvl.level_id] = [int]$lvl.sequence
    $requiredCriteriaByLevel[$lvl.level_id] = @($lvl.criteria | Where-Object { $_.required -eq $true } | ForEach-Object { $_.criterion_id })
}

# Rule: rejection and needs_update must include comment
foreach ($event in $reviewEvents) {
    if (($event.decision -eq "rejected" -or $event.decision -eq "needs_update") -and [string]::IsNullOrWhiteSpace([string]$event.comment)) {
        Add-ValidationError "Review event $($event.event_id) has decision $($event.decision) without comment."
    }
}

# Rule: promotion transitions must be monotonic unless rollback=true and reason exists
foreach ($event in $promotionEvents) {
    $from = $levelSequence[$event.from_level_id]
    $to = $levelSequence[$event.to_level_id]
    $rollback = $false
    if ($null -ne $event.rollback) {
        $rollback = [bool]$event.rollback
    }

    if ($to -lt $from -and -not $rollback) {
        Add-ValidationError "Promotion event $($event.event_id) has descending transition without rollback=true."
    }

    if ($rollback -and [string]::IsNullOrWhiteSpace([string]$event.reason)) {
        Add-ValidationError "Promotion event $($event.event_id) rollback is true but reason is empty."
    }
}

# Rule: no promotion to target level unless all required criteria for that target are approved in progress record
$progressById = @{}
foreach ($file in $progressFiles) {
    try {
        $p = Get-Content -Raw -Path $file.FullName | ConvertFrom-Json
        $progressById[$p.progress_id] = $p

        if (-not $levelSequence.ContainsKey($p.current_level_id) -or -not $levelSequence.ContainsKey($p.target_level_id)) {
            Add-ValidationError "Progress $($p.progress_id) contains unknown level id."
            continue
        }

        if ($levelSequence[$p.current_level_id] -gt $levelSequence[$p.target_level_id]) {
            Add-ValidationError "Progress $($p.progress_id) has current_level above target_level."
        }
    }
    catch {
        Add-ValidationError "Progress parse failure for $($file.FullName)."
    }
}

foreach ($event in $promotionEvents) {
    if (-not $progressById.ContainsKey($event.progress_id)) {
        Add-ValidationError "Promotion event $($event.event_id) references missing progress_id $($event.progress_id)."
        continue
    }

    $p = $progressById[$event.progress_id]
    $required = @()
    if ($requiredCriteriaByLevel.ContainsKey($event.to_level_id)) {
        $required = $requiredCriteriaByLevel[$event.to_level_id]
    }

    foreach ($criterionId in $required) {
        $status = $null
        if ($p.criterion_status.PSObject.Properties.Name -contains $criterionId) {
            $status = [string]$p.criterion_status.$criterionId
        }
        if ($status -ne "approved") {
            Add-ValidationError "Promotion event $($event.event_id) invalid: required criterion $criterionId is not approved."
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Validation failed with $($errors.Count) issue(s):" -ForegroundColor Red
    foreach ($e in $errors) {
        Write-Host "- $e" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Validation passed. All schemas and workflow checks are valid." -ForegroundColor Green
exit 0
