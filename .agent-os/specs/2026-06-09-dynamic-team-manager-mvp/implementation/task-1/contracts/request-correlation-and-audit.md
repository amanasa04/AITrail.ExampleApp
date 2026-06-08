# Request Correlation and Audit Middleware Contract

This document defines middleware requirements for Task 1.4.

## Correlation ID Behavior

- Header name: X-Correlation-Id.
- If request includes X-Correlation-Id, API reuses the provided value after sanitization.
- If header is missing, API generates a new UUID value.
- API returns the resolved correlation id in response header X-Correlation-Id.
- Correlation id is included in all structured logs and every error envelope.

## Error Envelope Contract

- All 4xx and 5xx API responses use a common envelope:
  - code: machine-readable identifier.
  - message: human-readable summary.
  - details: optional field-level issues.
  - correlationId: always present.
- Validation errors use code VALIDATION_FAILED.
- Authorization failures use AUTH_FORBIDDEN.
- Missing resources use NOT_FOUND.

## Audit Logging Behavior

- Middleware or endpoint filter writes one audit record per successful state-changing action.
- Required fields:
  - EntityType
  - EntityId
  - Action
  - ChangedBy
  - ChangedAtUtc
  - CorrelationId
- For writes that mutate existing state, include OldValuesJson and NewValuesJson snapshots.

## .NET 10 API Integration Notes

- Implement correlation middleware early in pipeline, before auth and exception handlers.
- Implement exception handling middleware to produce error envelope on unhandled exceptions.
- Implement audit logging via action filter or service inside command handlers to avoid duplicate writes.
- Ensure logger scope includes correlation id so all downstream logs are linked.
