import { useMemo, useState } from "react";
import { useAddMembership, useDeleteMembership, useTeam, useTeamMemberships, useUpdateMembership } from "../api/teams";
import { MembershipEditorDialog } from "../components/MembershipEditorDialog";

interface TeamDetailPageProps {
  teamId: number;
}

export function TeamDetailPage({ teamId }: TeamDetailPageProps) {
  const [role, setRole] = useState("");
  const [activeOnly, setActiveOnly] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);

  const { data: team } = useTeam(teamId);
  const { data: memberships } = useTeamMemberships(teamId, { role: role || undefined, activeOnly, page: 1, pageSize: 50 });
  const addMembership = useAddMembership(teamId);

  const deleteMembership = useMemo(
    () => (membershipId: number) => useDeleteMembership(membershipId, teamId),
    [teamId]
  );

  const updateMembership = useMemo(
    () => (membershipId: number) => useUpdateMembership(membershipId, teamId),
    [teamId]
  );

  return (
    <section>
      <h2>{team?.teamName ?? "Team"} Detail</h2>
      <h3>Roster</h3>

      <div>
        <label>
          role filter
          <input value={role} onChange={(event) => setRole(event.target.value)} placeholder="Manager, Lead, Member" />
        </label>

        <label>
          active only
          <input type="checkbox" checked={activeOnly} onChange={(event) => setActiveOnly(event.target.checked)} />
        </label>

        <button type="button" onClick={() => setDialogOpen(true)}>Add Member</button>
      </div>

      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Start</th>
            <th>End</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {(memberships?.items ?? []).map((item) => {
            const updateHook = updateMembership(item.teamMembershipId);
            const deleteHook = deleteMembership(item.teamMembershipId);

            return (
              <tr key={item.teamMembershipId}>
                <td>{item.employeeName}</td>
                <td>{item.email}</td>
                <td>{item.teamRole}</td>
                <td>{item.effectiveStartDate}</td>
                <td>{item.effectiveEndDate ?? "Active"}</td>
                <td>
                  <button
                    type="button"
                    onClick={() => updateHook.mutate({ teamRole: "Lead" })}
                  >
                    Promote to Lead
                  </button>
                  <button
                    type="button"
                    onClick={() => deleteHook.mutate("end")}
                  >
                    End Membership
                  </button>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>

      <MembershipEditorDialog
        isOpen={dialogOpen}
        onClose={() => setDialogOpen(false)}
        onSave={async (input) => {
          await addMembership.mutateAsync(input);
        }}
      />
    </section>
  );
}
