import { useState } from "react";
import type { UpsertMembershipInput } from "../types";

interface MembershipEditorDialogProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (value: UpsertMembershipInput) => Promise<void>;
}

export function MembershipEditorDialog({ isOpen, onClose, onSave }: MembershipEditorDialogProps) {
  const [employeeId, setEmployeeId] = useState<number | "">("");
  const [teamRole, setTeamRole] = useState("Member");
  const [effectiveStartDate, setEffectiveStartDate] = useState("");
  const [effectiveEndDate, setEffectiveEndDate] = useState("");
  const [isSaving, setIsSaving] = useState(false);

  if (!isOpen) {
    return null;
  }

  const canSubmit = Boolean(employeeId) && Boolean(teamRole) && Boolean(effectiveStartDate);

  async function submitForm() {
    if (!canSubmit) {
      return;
    }

    setIsSaving(true);
    try {
      await onSave({
        employeeId: Number(employeeId),
        teamRole,
        effectiveStartDate,
        effectiveEndDate: effectiveEndDate || undefined
      });
      onClose();
    } finally {
      setIsSaving(false);
    }
  }

  return (
    <div aria-label="Membership editor dialog">
      <h3>Add or Edit Membership</h3>
      <label>
        employee lookup
        <input
          aria-label="employee"
          value={employeeId}
          onChange={(event) => setEmployeeId(event.target.value === "" ? "" : Number(event.target.value))}
          placeholder="Enter employee id"
        />
      </label>

      <label>
        Team role
        <select aria-label="teamRole" value={teamRole} onChange={(event) => setTeamRole(event.target.value)}>
          <option value="Manager">Manager</option>
          <option value="Lead">Lead</option>
          <option value="Member">Member</option>
        </select>
      </label>

      <label>
        Effective start date
        <input
          aria-label="effectiveStartDate"
          type="date"
          value={effectiveStartDate}
          onChange={(event) => setEffectiveStartDate(event.target.value)}
        />
      </label>

      <label>
        Effective end date
        <input
          aria-label="effectiveEndDate"
          type="date"
          value={effectiveEndDate}
          onChange={(event) => setEffectiveEndDate(event.target.value)}
        />
      </label>

      <button type="button" onClick={onClose}>Cancel</button>
      <button type="button" disabled={!canSubmit || isSaving} onClick={submitForm}>
        {isSaving ? "Saving..." : "Save membership"}
      </button>
    </div>
  );
}
