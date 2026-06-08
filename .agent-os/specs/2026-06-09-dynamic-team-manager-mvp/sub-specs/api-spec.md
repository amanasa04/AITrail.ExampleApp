# API Specification

This is the API specification for the spec detailed in .agent-os/specs/2026-06-09-dynamic-team-manager-mvp/spec.md

## API Conventions

- Base path: /api/v1
- Auth: Entra ID/Easy Auth bearer context, role policy enforced per endpoint.
- Content type: application/json unless explicitly CSV endpoint.
- Standard error envelope: code, message, details, correlationId.

## Endpoints

### POST /api/v1/teams

**Purpose:** Create a new team.
**Roles:** Team Editor, HR Analyst, Admin.
**Request Body:** teamCode, teamName, ownerEmployeeId (optional), department (optional).
**Response:** 201 Created with Team resource.
**Errors:** 400 validation failure, 401 unauthorized, 403 forbidden, 409 duplicate teamCode.

### GET /api/v1/teams

**Purpose:** List teams with filters and paging.
**Roles:** Employee, Team Editor, HR Analyst, Admin.
**Query Params:** status, department, ownerEmployeeId, search, page, pageSize, sort.
**Response:** 200 OK with paged team list.
**Errors:** 400 invalid query, 401 unauthorized.

### GET /api/v1/teams/{teamId}

**Purpose:** Get details for a single team.
**Roles:** Employee, Team Editor, HR Analyst, Admin.
**Response:** 200 OK with Team resource.
**Errors:** 401 unauthorized, 404 team not found.

### PATCH /api/v1/teams/{teamId}

**Purpose:** Rename or update mutable team fields.
**Roles:** Team Editor, HR Analyst, Admin.
**Request Body:** teamName (optional), ownerEmployeeId (optional), department (optional), status (optional).
**Response:** 200 OK with updated Team resource.
**Errors:** 400 validation failure, 401 unauthorized, 403 forbidden, 404 not found.

### DELETE /api/v1/teams/{teamId}

**Purpose:** Archive a team (soft delete behavior).
**Roles:** HR Analyst, Admin.
**Response:** 204 No Content.
**Errors:** 401 unauthorized, 403 forbidden, 404 not found, 409 cannot archive due to policy constraints.

### POST /api/v1/teams/{teamId}/memberships

**Purpose:** Add an employee membership to a team.
**Roles:** Team Editor, HR Analyst, Admin.
**Request Body:** employeeId, teamRole, effectiveStartDate, effectiveEndDate (optional).
**Response:** 201 Created with TeamMembership resource.
**Errors:** 400 validation failure, 401 unauthorized, 403 forbidden, 404 team or employee not found, 409 overlapping assignment policy violation.

### GET /api/v1/teams/{teamId}/memberships

**Purpose:** List memberships for a team roster.
**Roles:** Employee, Team Editor, HR Analyst, Admin.
**Query Params:** activeOnly, role, search, page, pageSize, sort.
**Response:** 200 OK with paged roster records including basic contact fields.
**Errors:** 400 invalid query, 401 unauthorized, 404 team not found.

### PATCH /api/v1/memberships/{teamMembershipId}

**Purpose:** Update team role or effective date range for an existing membership.
**Roles:** Team Editor, HR Analyst, Admin.
**Request Body:** teamRole (optional), effectiveStartDate (optional), effectiveEndDate (optional).
**Response:** 200 OK with updated TeamMembership.
**Errors:** 400 validation failure, 401 unauthorized, 403 forbidden, 404 membership not found.

### DELETE /api/v1/memberships/{teamMembershipId}

**Purpose:** End membership or remove erroneous membership per policy.
**Roles:** Team Editor, HR Analyst, Admin.
**Query Params:** mode=end|remove.
**Response:** 204 No Content.
**Errors:** 400 invalid mode, 401 unauthorized, 403 forbidden, 404 not found.

### GET /api/v1/search/memberships

**Purpose:** Cross-team membership search with flexible filters.
**Roles:** Team Editor, HR Analyst, Admin.
**Query Params:** teamId, employeeId, employeeName, role, department, isActive, fromDate, toDate, page, pageSize, sort.
**Response:** 200 OK with paged membership search results.
**Errors:** 400 invalid query, 401 unauthorized, 403 forbidden.

### GET /api/v1/reports/team-size

**Purpose:** Return team-size snapshot for selected date or period.
**Roles:** Team Editor, HR Analyst, Admin.
**Query Params:** asOfDate or periodStart and periodEnd, teamId (optional), department (optional).
**Response:** 200 OK with aggregate counts by team.
**Errors:** 400 invalid query, 401 unauthorized, 403 forbidden.

### GET /api/v1/reports/membership-trends

**Purpose:** Return joiners/leavers trend aggregates for selected period.
**Roles:** Team Editor, HR Analyst, Admin.
**Query Params:** periodStart, periodEnd, interval (weekly|monthly), teamId (optional), department (optional).
**Response:** 200 OK with time-series aggregate payload.
**Errors:** 400 invalid query, 401 unauthorized, 403 forbidden.

### GET /api/v1/exports/memberships.csv

**Purpose:** Export current filtered membership view to CSV.
**Roles:** Team Editor, HR Analyst, Admin.
**Query Params:** same as search endpoint filters.
**Response:** 200 OK with text/csv content-disposition attachment.
**Errors:** 400 invalid query, 401 unauthorized, 403 forbidden.

## Controller Responsibilities

- TeamsController: team CRUD lifecycle, team validation, authorization checks.
- TeamMembershipsController: membership create/update/end/remove flows and policy validation.
- SearchController: federated filtering and pagination for cross-team queries.
- ReportsController: aggregate reporting queries and output shaping.
- ExportsController: CSV projection and streaming for filtered datasets.

## Business Logic Rules

- Team code uniqueness is enforced on create.
- Archived teams cannot receive new memberships.
- Membership effective end date cannot be earlier than start date.
- Authorization policies apply both at endpoint and resource ownership scope where required.
- All state-changing requests write an audit log entry with before/after values.

## Error Handling

- Validation errors return 400 with field-level details.
- Authorization failures return 403 with policy identifier when safe.
- Not found returns 404 for missing team/membership resources.
- Conflict returns 409 for duplicate keys and assignment rule conflicts.
