using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DynamicTeamManager.Api.Controllers;

[ApiController]
[Route("api/v1/reports")]
public sealed class ReportsController : ControllerBase
{
  private readonly IReportsService _reportsService;

  public ReportsController(IReportsService reportsService)
  {
    _reportsService = reportsService;
  }

  [HttpGet("team-size")]
  [Authorize(Policy = "Reports.Read")]
  public async Task<ActionResult<IReadOnlyList<TeamSizeRow>>> GetTeamSize([FromQuery] TeamSizeReportQuery query, CancellationToken ct)
  {
    IReadOnlyList<TeamSizeRow> rows = await _reportsService.GetTeamSizeAsync(query, ct);
    return Ok(rows);
  }

  [HttpGet("membership-trends")]
  [Authorize(Policy = "Reports.Read")]
  public async Task<ActionResult<IReadOnlyList<MembershipTrendRow>>> GetMembershipTrends([FromQuery] MembershipTrendsQuery query, CancellationToken ct)
  {
    IReadOnlyList<MembershipTrendRow> rows = await _reportsService.GetMembershipTrendsAsync(query, ct);
    return Ok(rows);
  }
}

public interface IReportsService
{
  Task<IReadOnlyList<TeamSizeRow>> GetTeamSizeAsync(TeamSizeReportQuery query, CancellationToken ct);
  Task<IReadOnlyList<MembershipTrendRow>> GetMembershipTrendsAsync(MembershipTrendsQuery query, CancellationToken ct);
}
