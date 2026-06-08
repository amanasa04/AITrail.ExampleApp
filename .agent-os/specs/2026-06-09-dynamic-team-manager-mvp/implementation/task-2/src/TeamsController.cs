using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DynamicTeamManager.Api.Controllers;

[ApiController]
[Route("api/v1/teams")]
public sealed class TeamsController : ControllerBase
{
  private readonly ITeamService _teamService;
  private readonly IAuditWriter _auditWriter;

  public TeamsController(ITeamService teamService, IAuditWriter auditWriter)
  {
    _teamService = teamService;
    _auditWriter = auditWriter;
  }

  [HttpPost]
  [Authorize(Policy = "Teams.Write")]
  public async Task<IActionResult> CreateTeam([FromBody] CreateTeamRequest request, CancellationToken ct)
  {
    TeamDto created = await _teamService.CreateTeamAsync(request, ct);
    await _auditWriter.WriteAsync(AuditEvent.ForCreate("Team", created.TeamId.ToString(), User.Identity?.Name ?? "unknown", request, created), ct);
    return CreatedAtAction(nameof(GetTeamById), new { teamId = created.TeamId }, created);
  }

  [HttpGet]
  [Authorize(Policy = "Teams.Read")]
  public async Task<ActionResult<PagedResult<TeamDto>>> GetTeams([FromQuery] TeamListQuery query, CancellationToken ct)
  {
    return Ok(await _teamService.GetTeamsAsync(query, ct));
  }

  [HttpGet("{teamId:long}")]
  [Authorize(Policy = "Teams.Read")]
  public async Task<ActionResult<TeamDto>> GetTeamById([FromRoute] long teamId, CancellationToken ct)
  {
    TeamDto? team = await _teamService.GetTeamByIdAsync(teamId, ct);
    if (team is null)
    {
      return NotFound();
    }

    return Ok(team);
  }

  [HttpPatch("{teamId:long}")]
  [Authorize(Policy = "Teams.Write")]
  public async Task<ActionResult<TeamDto>> UpdateTeam([FromRoute] long teamId, [FromBody] UpdateTeamRequest request, CancellationToken ct)
  {
    TeamDto? before = await _teamService.GetTeamByIdAsync(teamId, ct);
    TeamDto updated = await _teamService.UpdateTeamAsync(teamId, request, ct);
    await _auditWriter.WriteAsync(AuditEvent.ForUpdate("Team", teamId.ToString(), User.Identity?.Name ?? "unknown", before, updated), ct);
    return Ok(updated);
  }

  [HttpDelete("{teamId:long}")]
  [Authorize(Policy = "Teams.Admin")]
  public async Task<IActionResult> ArchiveTeam([FromRoute] long teamId, CancellationToken ct)
  {
    TeamDto? before = await _teamService.GetTeamByIdAsync(teamId, ct);
    await _teamService.ArchiveTeamAsync(teamId, ct);
    await _auditWriter.WriteAsync(AuditEvent.ForUpdate("Team", teamId.ToString(), User.Identity?.Name ?? "unknown", before, new { status = "Archived" }), ct);
    return NoContent();
  }
}

public interface ITeamService
{
  Task<TeamDto> CreateTeamAsync(CreateTeamRequest request, CancellationToken ct);
  Task<PagedResult<TeamDto>> GetTeamsAsync(TeamListQuery query, CancellationToken ct);
  Task<TeamDto?> GetTeamByIdAsync(long teamId, CancellationToken ct);
  Task<TeamDto> UpdateTeamAsync(long teamId, UpdateTeamRequest request, CancellationToken ct);
  Task ArchiveTeamAsync(long teamId, CancellationToken ct);
}

public sealed record TeamDto(long TeamId, string TeamCode, string TeamName, string Status);
public sealed record CreateTeamRequest(string TeamCode, string TeamName, long? OwnerEmployeeId, string? Department);
public sealed record UpdateTeamRequest(string? TeamName, long? OwnerEmployeeId, string? Department, string? Status);
public sealed record TeamListQuery(string? Status, string? Department, long? OwnerEmployeeId, string? Search, int Page = 1, int PageSize = 25, string? Sort = null);
public sealed record PagedResult<T>(IReadOnlyList<T> Items, int Page, int PageSize, int TotalCount);
