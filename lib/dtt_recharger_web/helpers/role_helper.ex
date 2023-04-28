defmodule DttRechargerWeb.Helpers.RoleHelper do
  alias DttRecharger.Operations.OrganizationRoleOperation
  def user_org_role(user, org_id) do
    OrganizationRoleOperation.get_user_org_role_name(user, org_id)
  end

  def org_role(user, org_id) do
    OrganizationRoleOperation.get_user_org_role(user, org_id)
  end

  def user_invitation_status(user, org_id \\ nil) do
    cond do
      Enum.member?(["admin"], user.role.name) && user.sign_in_count <= 0 ->
        "Pending"
      Enum.member?(["user"], user.role.name) && org_role(user, org_id).sign_in_count <= 0 ->
        "Pending"
      true ->
        "Joined"
    end
  end
end
