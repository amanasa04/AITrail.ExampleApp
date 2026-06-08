# Report Definitions

## Team-Size Snapshot

- Route: GET /api/v1/reports/team-size
- Inputs:
  - asOfDate or periodStart and periodEnd
  - optional teamId and department filters
- Output:
  - list of TeamSizeRow values
  - columns: TeamId, TeamName, MemberCount

## Membership Trends

- Route: GET /api/v1/reports/membership-trends
- Inputs:
  - periodStart, periodEnd, interval (weekly or monthly)
  - optional teamId and department filters
- Output:
  - list of MembershipTrendRow values
  - columns: BucketDate, Joiners, Leavers

## Aggregation Rules

- Team-size counts only active memberships for selected date window.
- Trend joiners include memberships where start date falls in bucket.
- Trend leavers include memberships where end date falls in bucket.
- Archived teams are excluded unless explicitly requested in future enhancement.
