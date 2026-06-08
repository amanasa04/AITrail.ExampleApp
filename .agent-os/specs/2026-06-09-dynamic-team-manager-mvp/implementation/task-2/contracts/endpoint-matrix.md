# Task 2 Endpoint Matrix

## TeamsController

- POST /api/v1/teams
  - Policy: Teams.Write
  - Behavior: Create team, return 201, write Create audit event.
- GET /api/v1/teams
  - Policy: Teams.Read
  - Behavior: Paged list with query filters.
- GET /api/v1/teams/{teamId}
  - Policy: Teams.Read
  - Behavior: Return team by id or 404.
- PATCH /api/v1/teams/{teamId}
  - Policy: Teams.Write
  - Behavior: Update mutable team fields, return 200, write Update audit event.
- DELETE /api/v1/teams/{teamId}
  - Policy: Teams.Admin
  - Behavior: Archive team, return 204, write Update audit event with status Archived.

## TeamMembershipsController

- POST /api/v1/teams/{teamId}/memberships
  - Policy: Memberships.Write
  - Behavior: Add membership, return 201, write Create audit event.
- GET /api/v1/teams/{teamId}/memberships
  - Policy: Memberships.Read
  - Behavior: Paged team roster with filters.
- PATCH /api/v1/memberships/{teamMembershipId}
  - Policy: Memberships.Write
  - Behavior: Update role/date fields, return 200, write Update audit event.
- DELETE /api/v1/memberships/{teamMembershipId}?mode=end|remove
  - Policy: Memberships.Write
  - Behavior: End or remove membership, return 204, write Delete audit event.

## Business Rule Contracts

- Team code uniqueness and archived-team edit restrictions are enforced by service layer.
- Membership date range rules are enforced by service layer and SQL constraint checks.
- Every write endpoint produces audit record with actor and before/after payloads.
