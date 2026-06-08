using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DynamicTeamManager.Api.Controllers;

[ApiController]
[Route("api/v1")]
public sealed class TeamMembershipsController : ControllerBase
{
  private readonly ITeamMembershipService _membershipService;
  private readonly IAuditWriter _auditWriter;

  public TeamMembershipsController(ITeamMembershipService membershipService, IAuditWriter auditWriter)
  {
    _membershipService = membershipService;
    _auditWriter = auditWriter;
  }

  [HttpPost("teams/{teamId:long}/memberships")]
  [Authorize(Policy = "Memberships.Write")]
  public async Task<IActionResult> AddMembership([FromRoute] long teamId, [FromBody] CreateMembershipRequest request, CancellationToken ct)
  {
    TeamMembershipDto created = await _membershipService.AddMembershipAsync(teamId, request, ct);
    await _auditWriter.WriteAsync(AuditEvent.ForCreate("TeamMembership", created.TeamMembershipId.ToString(), User.Identity?.Name ?? "unknown", request, created), ct);
    return CreatedAtAction(nameof(GetTeamMemberships), new { teamId }, created);
  }

  [HttpGet("teams/{teamId:long}/memberships")]
  [Authorize(Policy = "Memberships.Read")]
  public async Task<ActionResult<PagedResult<TeamMembershipDto>>> GetTeamMemberships([FromRoute] long teamId, [FromQuery] MembershipListQuery query, CancellationToken ct)
  {
    return Ok(await _membershipService.GetTeamMembershipsAsync(teamId, query, ct));
  }

  [HttpPatch("memberships/{teamMembershipId:long}")]
  [Authorize(Policy = "Memberships.Write")]
  public async Task<ActionResult<TeamMembershipDto>> UpdateMembership([FromRoute] long teamMembershipId, [FromBody] UpdateMembershipRequest request, CancellationToken ct)
  {
    TeamMembershipDto? before = await _membershipService.GetByIdAsync(teamMembershipId, ct);
    TeamMembershipDto updated = await _membershipService.UpdateMembershipAsync(teamMembershipId, request, ct);
    await _auditWriter.WriteAsync(AuditEvent.ForUpdate("TeamMembership", teamMembershipId.ToString(), User.Identity?.Name ?? "unknown", before, updated), ct);
    return Ok(updated);
  }

  [HttpDelete("memberships/{teamMembershipId:long}")]
  [Authorize(Policy = "Memberships.Write")]
  public async Task<IActionResult> DeleteMembership([FromRoute] long teamMembershipId, [FromQuery] string mode, CancellationToken ct)
  {
    TeamMembershipDto? before = await _membershipService.GetByIdAsync(teamMembershipId, ct);
    await _membershipService.DeleteMembershipAsync(teamMembershipId, mode, ct);
    await _auditWriter.WriteAsync(AuditEvent.ForDelete("TeamMembership", teamMembershipId.ToString(), User.Identity?.Name ?? "unknown", before), ct);
    return NoContent();
  }
}

public interface ITeamMembershipService
{
  Task<TeamMembershipDto> AddMembershipAsync(long teamId, CreateMembershipRequest request, CancellationToken ct);
  Task<PagedResult<TeamMembershipDto>> GetTeamMembershipsAsync(long teamId, MembershipListQuery query, CancellationToken ct);
  Task<TeamMembershipDto?> GetByIdAsync(long teamMembershipId, CancellationToken ct);
  Task<TeamMembershipDto> UpdateMembershipAsync(long teamMembershipId, UpdateMembershipRequest request, CancellationToken ct);
  Task DeleteMembershipAsync(long teamMembershipId, string mode, CancellationToken ct);
}

public sealed record TeamMembershipDto(long TeamMembershipId, long TeamId, long EmployeeId, string TeamRole, DateOnly EffectiveStartDate, DateOnly? EffectiveEndDate);
public sealed record CreateMembershipRequest(long EmployeeId, string TeamRole, DateOnly EffectiveStartDate, DateOnly? EffectiveEndDate);
public sealed record UpdateMembershipRequest(string? TeamRole, DateOnly? EffectiveStartDate, DateOnly? EffectiveEndDate);
public sealed record MembershipListQuery(bool ActiveOnly = true, string? Role = null, string? Search = null, int Page = 1, int PageSize = 25, string? Sort = null);
