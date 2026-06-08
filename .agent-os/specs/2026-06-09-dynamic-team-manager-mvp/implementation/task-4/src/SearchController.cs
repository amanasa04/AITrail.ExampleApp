using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DynamicTeamManager.Api.Controllers;

[ApiController]
[Route("api/v1/search/memberships")]
public sealed class SearchController : ControllerBase
{
  private readonly ISearchService _searchService;

  public SearchController(ISearchService searchService)
  {
    _searchService = searchService;
  }

  [HttpGet]
  [Authorize(Policy = "Search.Read")]
  public async Task<ActionResult<PagedResult<MembershipSearchRow>>> SearchMemberships([FromQuery] SearchMembershipsQuery query, CancellationToken ct)
  {
    // Search is server-side and supports paging and sorting for large rosters.
    PagedResult<MembershipSearchRow> result = await _searchService.SearchMembershipsAsync(query, ct);
    return Ok(result);
  }
}

public interface ISearchService
{
  Task<PagedResult<MembershipSearchRow>> SearchMembershipsAsync(SearchMembershipsQuery query, CancellationToken ct);
}
