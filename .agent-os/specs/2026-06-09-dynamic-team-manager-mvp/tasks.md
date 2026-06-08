# Spec Tasks

## Tasks

- [x] 1. Establish foundation: auth, roles, schema, and observability
  - [x] 1.1 Write tests for role authorization policies, validation contracts, and audit logging behavior.
  - [x] 1.2 Implement SQL schema migrations for Employees, Teams, TeamMemberships, and AuditLogs with required indexes and constraints.
  - [x] 1.3 Implement Entra ID/Easy Auth identity mapping and backend role policy enforcement (Employee, Team Editor, HR Analyst, Admin).
  - [x] 1.4 Implement shared API error envelope (code, message, details, correlationId) and request correlation middleware.
  - [x] 1.5 Verify all tests pass.

- [x] 2. Implement team lifecycle and membership APIs
  - [x] 2.1 Write tests for Teams and TeamMemberships endpoints including create, update, archive, and effective-date rules.
  - [x] 2.2 Build TeamsController endpoints: create, list, get, update, archive with validation and conflict handling.
  - [x] 2.3 Build TeamMembershipsController endpoints: add, list, update, end/remove membership with date-range and policy validation.
  - [x] 2.4 Persist audit entries for all write actions with before/after snapshots and actor metadata.
  - [x] 2.5 Verify all tests pass.

- [x] 3. Deliver frontend team and roster management experience
  - [x] 3.1 Write UI and integration tests for team list/detail pages, membership edit flow, and permission-based action visibility.
  - [x] 3.2 Implement React Query service layer for teams and memberships with server-side paging, sorting, retries, and cache invalidation.
  - [x] 3.3 Build Team List and Team Detail pages with create/rename/archive actions and roster tab filters.
  - [x] 3.4 Build membership add/edit/remove flows with employee lookup, role selection, effective dates, and inline validation states.
  - [x] 3.5 Verify all tests pass.

- [x] 4. Implement cross-team search, reporting, and CSV export
  - [x] 4.1 Write tests for search filters, report aggregation accuracy, and CSV output shape/permissions.
  - [x] 4.2 Implement search endpoint for cross-team membership queries with filtering, paging, and sorting.
  - [x] 4.3 Implement reporting endpoints for team-size snapshots and membership trends across a selected period.
  - [x] 4.4 Implement CSV export endpoint that mirrors active filters and enforces role-based field visibility.
  - [x] 4.5 Verify all tests pass.

- [x] 5. Harden, validate performance, and prepare release
  - [x] 5.1 Write non-functional test scenarios for P95 response targets, export throughput, and audit trace completeness.
  - [x] 5.2 Run end-to-end validation across core user workflows: manager updates, HR audit/search, employee self-verification, admin reporting/export.
  - [x] 5.3 Validate performance goals: common roster/search queries <= 2 seconds P95, CSV export of 10k rows <= 30 seconds.
  - [x] 5.4 Finalize runbook notes and deployment checklist for standard CI/CD promotion across dev, test, and production.
  - [x] 5.5 Verify all tests pass.

## Execution order notes

- Complete Task 1 before any feature implementation to avoid rework in auth, schema, and error contracts.
- Execute Task 2 before Task 3 so frontend development uses stable API contracts.
- Task 4 can begin after core memberships are available from Task 2.
- Task 5 is the release gate and should only start after Tasks 2 to 4 are functionally complete.
