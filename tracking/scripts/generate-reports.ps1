$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$trackingDir = Resolve-Path (Join-Path $scriptDir "..")
$rubricPath = Join-Path $trackingDir "rubric/rubric.v1.json"
$progressDir = Join-Path $trackingDir "progress"
$reviewEventsPath = Join-Path $trackingDir "events/review-events.jsonl"
$reportDir = Join-Path $trackingDir "reports"

if (-not (Test-Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir | Out-Null
}

function Read-Jsonl {
    param([string]$Path)
    $items = @()
    if (-not (Test-Path $Path)) {
        return $items
    }

    foreach ($line in (Get-Content -Path $Path)) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        $items += ($line | ConvertFrom-Json)
    }
    return $items
}

$rubric = Get-Content -Raw -Path $rubricPath | ConvertFrom-Json
$requiredCriteriaByLevel = @{}
foreach ($lvl in $rubric.levels) {
    $requiredCriteriaByLevel[$lvl.level_id] = @($lvl.criteria | Where-Object { $_.required -eq $true } | ForEach-Object { $_.criterion_id })
}

$progressFiles = Get-ChildItem -Path $progressDir -Filter "*.json" -File -ErrorAction SilentlyContinue
$progress = @()
foreach ($f in $progressFiles) {
    $progress += (Get-Content -Raw -Path $f.FullName | ConvertFrom-Json)
}

$reviewEvents = Read-Jsonl -Path $reviewEventsPath

$individualRows = @()
foreach ($p in $progress) {
    $required = @()
    if ($requiredCriteriaByLevel.ContainsKey($p.target_level_id)) {
        $required = $requiredCriteriaByLevel[$p.target_level_id]
    }

    $requiredTotal = $required.Count
    $requiredApproved = 0
    $pendingReviews = 0

    foreach ($criterionId in $required) {
        $status = "not_started"
        if ($p.criterion_status.PSObject.Properties.Name -contains $criterionId) {
            $status = [string]$p.criterion_status.$criterionId
        }

        if ($status -eq "approved") {
            $requiredApproved++
        }
        if ($status -eq "in_review") {
            $pendingReviews++
        }
    }

    $individualRows += [pscustomobject]@{
        user_id = $p.user_id
        user_name = $p.user_name
        team = $p.team
        current_level_id = $p.current_level_id
        target_level_id = $p.target_level_id
        readiness_state = $p.readiness_state
        required_total = $requiredTotal
        required_approved = $requiredApproved
        pending_reviews = $pendingReviews
    }
}

$levelRows = $progress |
    Group-Object -Property current_level_id |
    ForEach-Object {
        [pscustomobject]@{
            current_level_id = $_.Name
            user_count = $_.Count
        }
    }

$pendingReviewRows = @()
foreach ($p in $progress) {
    $required = @()
    if ($requiredCriteriaByLevel.ContainsKey($p.target_level_id)) {
        $required = $requiredCriteriaByLevel[$p.target_level_id]
    }

    foreach ($criterionId in $required) {
        $status = "not_started"
        if ($p.criterion_status.PSObject.Properties.Name -contains $criterionId) {
            $status = [string]$p.criterion_status.$criterionId
        }

        if ($status -eq "in_review") {
            $pendingReviewRows += [pscustomobject]@{
                progress_id = $p.progress_id
                user_id = $p.user_id
                user_name = $p.user_name
                team = $p.team
                criterion_id = $criterionId
                status = $status
            }
        }
    }
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$individualPath = Join-Path $reportDir ("{0}-individual-readiness.csv" -f $timestamp)
$teamPath = Join-Path $reportDir ("{0}-team-level-distribution.csv" -f $timestamp)
$pendingPath = Join-Path $reportDir ("{0}-pending-review-queue.csv" -f $timestamp)

$individualRows | Export-Csv -Path $individualPath -NoTypeInformation -Encoding UTF8
$levelRows | Export-Csv -Path $teamPath -NoTypeInformation -Encoding UTF8
$pendingReviewRows | Export-Csv -Path $pendingPath -NoTypeInformation -Encoding UTF8

Write-Host "Generated reports:" -ForegroundColor Green
Write-Host "- $individualPath"
Write-Host "- $teamPath"
Write-Host "- $pendingPath"
