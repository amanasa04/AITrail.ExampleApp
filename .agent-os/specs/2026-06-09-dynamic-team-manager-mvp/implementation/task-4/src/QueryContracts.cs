namespace DynamicTeamManager.Api.Controllers;

public sealed record SearchMembershipsQuery(
  long? TeamId,
  long? EmployeeId,
  string? EmployeeName,
  string? Role,
  string? Department,
  bool? IsActive,
  DateOnly? FromDate,
  DateOnly? ToDate,
  int Page = 1,
  int PageSize = 25,
  string? Sort = null);

public sealed record TeamSizeReportQuery(
  DateOnly? AsOfDate,
  DateOnly? PeriodStart,
  DateOnly? PeriodEnd,
  long? TeamId,
  string? Department);

public sealed record MembershipTrendsQuery(
  DateOnly PeriodStart,
  DateOnly PeriodEnd,
  string Interval,
  long? TeamId,
  string? Department);

public sealed record MembershipSearchRow(
  long TeamMembershipId,
  long TeamId,
  string TeamName,
  long EmployeeId,
  string EmployeeName,
  string Email,
  string TeamRole,
  bool IsActive,
  DateOnly EffectiveStartDate,
  DateOnly? EffectiveEndDate);

public sealed record TeamSizeRow(long TeamId, string TeamName, int MemberCount);
public sealed record MembershipTrendRow(DateOnly BucketDate, int Joiners, int Leavers);
