export type TeamStatus = "Active" | "Archived";

export interface Team {
  teamId: number;
  teamCode: string;
  teamName: string;
  status: TeamStatus;
  ownerEmployeeId?: number;
  department?: string;
}

export interface TeamMembership {
  teamMembershipId: number;
  teamId: number;
  employeeId: number;
  employeeName: string;
  email: string;
  title?: string;
  location?: string;
  teamRole: string;
  effectiveStartDate: string;
  effectiveEndDate?: string;
}

export interface PagedResult<T> {
  items: T[];
  page: number;
  pageSize: number;
  totalCount: number;
}

export interface TeamListFilters {
  status?: TeamStatus;
  department?: string;
  ownerEmployeeId?: number;
  search?: string;
  page?: number;
  pageSize?: number;
  sort?: string;
}

export interface MembershipFilters {
  activeOnly?: boolean;
  role?: string;
  search?: string;
  page?: number;
  pageSize?: number;
  sort?: string;
}

export interface UpsertMembershipInput {
  employeeId: number;
  teamRole: string;
  effectiveStartDate: string;
  effectiveEndDate?: string;
}
