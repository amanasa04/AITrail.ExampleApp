# Non-Functional Test Scenarios

## Performance

1. Roster search P95 latency
- Objective: Verify common roster/search requests stay at or below 2 seconds P95.
- Method: Execute representative filtered queries across normal volume dataset.
- Pass criteria: P95 <= 2.0 seconds.

2. Membership CSV export throughput
- Objective: Verify export for 10,000 rows completes within 30 seconds.
- Method: Execute export endpoint with high-cardinality filters.
- Pass criteria: duration <= 30 seconds.

3. Authenticated page load
- Objective: Verify first meaningful page load within target envelope.
- Method: Measure initial team list page load over normal internal network profile.
- Pass criteria: <= 3 seconds.

## Reliability and Auditability

4. Audit completeness under concurrent updates
- Objective: Ensure all write operations emit audit records with correlation id.
- Method: Simulate concurrent team and membership updates; inspect audit logs.
- Pass criteria: 100 percent write operations have corresponding audit record.

5. Error-envelope consistency
- Objective: Ensure 4xx and 5xx responses include standard contract fields.
- Method: Trigger validation and authorization failures intentionally.
- Pass criteria: response includes code, message, and correlationId.

## Security

6. Role-policy enforcement
- Objective: Ensure policy restrictions are enforced for read/write/export endpoints.
- Method: Execute endpoint matrix with Employee, TeamEditor, HRAnalyst, and Admin identities.
- Pass criteria: only authorized roles succeed.
