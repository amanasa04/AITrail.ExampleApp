# Dynamic Team Manager MVP Runbook

## Service overview

- Frontend: React and Vite web client.
- Backend: .NET 10 Web API.
- Data: SQL Server with effective-dated team memberships.
- Auth: Entra ID or Easy Auth with policy-based authorization.

## Operational checks

1. Confirm API health endpoint and auth middleware readiness.
2. Confirm SQL connectivity and migration state.
3. Confirm search, reports, and CSV export endpoints return expected responses.
4. Confirm write endpoints produce audit log records.

## Incident triage

1. Gather correlation id from failing request.
2. Review API logs using correlation id.
3. Verify role claim and policy mapping for affected user.
4. Validate database constraints for membership effective dates.
5. Re-run targeted validation scripts under implementation task folders.

## Rollback guidance

1. Revert deployment to previous known good API and frontend artifact.
2. Do not delete audit or membership history records.
3. If migration rollback is required, execute approved SQL rollback scripts with DBA approval.

## Support handoff

- Primary owner: Engineering operations admin.
- Secondary owner: HR systems analyst.
- Escalation: platform team for authentication and hosting issues.
