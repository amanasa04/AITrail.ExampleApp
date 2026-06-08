namespace DynamicTeamManager.Api.Controllers;

public interface IAuditWriter
{
  Task WriteAsync(AuditEvent auditEvent, CancellationToken ct);
}

public sealed record AuditEvent(
  string EntityType,
  string EntityId,
  string Action,
  string ChangedBy,
  object? OldValues,
  object? NewValues)
{
  public static AuditEvent ForCreate(string entityType, string entityId, string changedBy, object? request, object? created)
  {
    return new AuditEvent(entityType, entityId, "Create", changedBy, request, created);
  }

  public static AuditEvent ForUpdate(string entityType, string entityId, string changedBy, object? before, object? after)
  {
    return new AuditEvent(entityType, entityId, "Update", changedBy, before, after);
  }

  public static AuditEvent ForDelete(string entityType, string entityId, string changedBy, object? before)
  {
    return new AuditEvent(entityType, entityId, "Delete", changedBy, before, null);
  }
}
