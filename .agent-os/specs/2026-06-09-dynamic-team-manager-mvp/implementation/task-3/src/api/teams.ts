import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { apiFetch, toQueryString } from "./client";
import type {
  MembershipFilters,
  PagedResult,
  Team,
  TeamListFilters,
  TeamMembership,
  UpsertMembershipInput
} from "../types";

const teamKeys = {
  all: ["teams"] as const,
  list: (filters: TeamListFilters) => ["teams", "list", filters] as const,
  detail: (teamId: number) => ["teams", "detail", teamId] as const,
  memberships: (teamId: number, filters: MembershipFilters) => ["teams", "memberships", teamId, filters] as const
};

export function useTeams(filters: TeamListFilters) {
  return useQuery({
    queryKey: teamKeys.list(filters),
    queryFn: () => apiFetch<PagedResult<Team>>(`/teams${toQueryString(filters)}`),
    staleTime: 60_000
  });
}

export function useTeam(teamId: number) {
  return useQuery({
    queryKey: teamKeys.detail(teamId),
    queryFn: () => apiFetch<Team>(`/teams/${teamId}`),
    enabled: teamId > 0
  });
}

export function useTeamMemberships(teamId: number, filters: MembershipFilters) {
  return useQuery({
    queryKey: teamKeys.memberships(teamId, filters),
    queryFn: () => apiFetch<PagedResult<TeamMembership>>(`/teams/${teamId}/memberships${toQueryString(filters)}`),
    enabled: teamId > 0
  });
}

export function useCreateTeam() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: Partial<Team>) => apiFetch<Team>("/teams", {
      method: "POST",
      body: JSON.stringify(payload)
    }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: teamKeys.all });
    }
  });
}

export function useRenameTeam(teamId: number) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (teamName: string) => apiFetch<Team>(`/teams/${teamId}`, {
      method: "PATCH",
      body: JSON.stringify({ teamName })
    }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: teamKeys.detail(teamId) });
      queryClient.invalidateQueries({ queryKey: teamKeys.all });
    }
  });
}

export function useArchiveTeam(teamId: number) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: () => apiFetch<void>(`/teams/${teamId}`, { method: "DELETE" }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: teamKeys.all });
    }
  });
}

export function useAddMembership(teamId: number) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: UpsertMembershipInput) => apiFetch<TeamMembership>(`/teams/${teamId}/memberships`, {
      method: "POST",
      body: JSON.stringify(payload)
    }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: teamKeys.memberships(teamId, {}) });
    }
  });
}

export function useUpdateMembership(teamMembershipId: number, teamId: number) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: Partial<UpsertMembershipInput>) => apiFetch<TeamMembership>(`/memberships/${teamMembershipId}`, {
      method: "PATCH",
      body: JSON.stringify(payload)
    }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: teamKeys.memberships(teamId, {}) });
    }
  });
}

export function useDeleteMembership(teamMembershipId: number, teamId: number) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (mode: "end" | "remove") => apiFetch<void>(`/memberships/${teamMembershipId}${toQueryString({ mode })}`, {
      method: "DELETE"
    }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: teamKeys.memberships(teamId, {}) });
    }
  });
}
