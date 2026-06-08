# CSV Export Columns and Permission Rules

Route: GET /api/v1/exports/memberships.csv

## Default columns

1. TeamId
2. TeamName
3. EmployeeId
4. EmployeeName
5. Email
6. TeamRole
7. IsActive
8. EffectiveStartDate
9. EffectiveEndDate

## Permission handling

- Export requires Export.Memberships policy.
- Export receives same filter input as search endpoint.
- CSV content must represent the same filtered dataset seen in search results.
- Future sensitive columns (phone, location) must be omitted unless role policy allows explicit inclusion.

## File behavior

- UTF-8 encoding.
- Content-Type: text/csv.
- Content-Disposition attachment header with deterministic filename.
