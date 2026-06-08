using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DynamicTeamManager.Api.Controllers;

[ApiController]
[Route("api/v1/exports")]
public sealed class ExportsController : ControllerBase
{
  private readonly IExportService _exportService;

  public ExportsController(IExportService exportService)
  {
    _exportService = exportService;
  }

  [HttpGet("memberships.csv")]
  [Authorize(Policy = "Export.Memberships")]
  public async Task<IActionResult> ExportMembershipsCsv([FromQuery] SearchMembershipsQuery query, CancellationToken ct)
  {
    IReadOnlyList<MembershipSearchRow> rows = await _exportService.GetMembershipExportRowsAsync(query, ct);
    string csv = CsvWriter.WriteMembershipRows(rows);
    byte[] bytes = Encoding.UTF8.GetBytes(csv);

    Response.Headers["Content-Disposition"] = "attachment; filename=memberships-export.csv";
    return File(bytes, "text/csv");
  }
}

public interface IExportService
{
  Task<IReadOnlyList<MembershipSearchRow>> GetMembershipExportRowsAsync(SearchMembershipsQuery query, CancellationToken ct);
}

internal static class CsvWriter
{
  public static string WriteMembershipRows(IReadOnlyList<MembershipSearchRow> rows)
  {
    var sb = new StringBuilder();
    sb.AppendLine("TeamId,TeamName,EmployeeId,EmployeeName,Email,TeamRole,IsActive,EffectiveStartDate,EffectiveEndDate");
    foreach (MembershipSearchRow row in rows)
    {
      sb.AppendLine(string.Join(",", new[]
      {
        row.TeamId.ToString(),
        Escape(row.TeamName),
        row.EmployeeId.ToString(),
        Escape(row.EmployeeName),
        Escape(row.Email),
        Escape(row.TeamRole),
        row.IsActive ? "true" : "false",
        row.EffectiveStartDate.ToString("yyyy-MM-dd"),
        row.EffectiveEndDate?.ToString("yyyy-MM-dd") ?? string.Empty
      }));
    }

    return sb.ToString();
  }

  private static string Escape(string value)
  {
    if (value.Contains(',') || value.Contains('"'))
    {
      return $"\"{value.Replace("\"", "\"\"")}\"";
    }

    return value;
  }
}
