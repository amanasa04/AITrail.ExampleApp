import { useState } from "react";
import { useArchiveTeam, useCreateTeam, useRenameTeam, useTeams } from "../api/teams";

export function TeamListPage() {
  const [statusFilter, setStatusFilter] = useState<"Active" | "Archived" | "">("Active");
  const [search, setSearch] = useState("");
  const [selectedTeamId, setSelectedTeamId] = useState<number | null>(null);

  const { data, isLoading } = useTeams({ status: statusFilter || undefined, search, page: 1, pageSize: 25 });
  const createTeam = useCreateTeam();
  const renameTeam = useRenameTeam(selectedTeamId ?? 0);
  const archiveTeam = useArchiveTeam(selectedTeamId ?? 0);

  async function createTeamHandler() {
    await createTeam.mutateAsync({
      teamCode: `TEAM-${Date.now()}`,
      teamName: "New Team",
      status: "Active"
    });
  }

  async function renameSelectedTeam() {
    if (!selectedTeamId) {
      return;
    }
    await renameTeam.mutateAsync(`Renamed Team ${selectedTeamId}`);
  }

  async function archiveSelectedTeam() {
    if (!selectedTeamId) {
      return;
    }
    await archiveTeam.mutateAsync();
  }

  return (
    <section>
      <h2>Team List</h2>

      <div>
        <label>
          Status
          <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value as "Active" | "Archived" | "")}> 
            <option value="">All</option>
            <option value="Active">Active</option>
            <option value="Archived">Archived</option>
          </select>
        </label>

        <label>
          Search
          <input value={search} onChange={(e) => setSearch(e.target.value)} />
        </label>

        <button type="button" onClick={createTeamHandler}>Create Team</button>
        <button type="button" onClick={renameSelectedTeam}>rename</button>
        <button type="button" onClick={archiveSelectedTeam}>archive</button>
      </div>

      {isLoading && <p>Loading teams...</p>}

      <ul>
        {(data?.items ?? []).map((team) => (
          <li key={team.teamId}>
            <button type="button" onClick={() => setSelectedTeamId(team.teamId)}>
              {team.teamName} ({team.status})
            </button>
          </li>
        ))}
      </ul>
    </section>
  );
}
