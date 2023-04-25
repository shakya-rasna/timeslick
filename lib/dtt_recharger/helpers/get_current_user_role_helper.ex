defmodule DttRecharger.Helpers.GetCurrentUserRoleHelper do
  import Ecto.Query, warn: false
  def current_user_role_helper(current_user, current_organization) do
    role = from r in DttRecharger.Schema.Role,
                join: ro in DttRecharger.Schema.OrganizationRole,
                on: r.id == ro.organization_id,
                where: ro.user_id ==  ^current_user.id and ro.organization_id == ^current_organization.id
    [role] = DttRecharger.Repo.all(role)
    role.name
  end
end
