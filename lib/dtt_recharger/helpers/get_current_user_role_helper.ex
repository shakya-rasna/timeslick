defmodule DttRecharger.Helpers.GetCurrentUserRoleHelper do

  def current_user_role_helper(current_user) do
    user_organization =  current_user |> DttRecharger.Repo.preload([organization_roles: :role])
    [organization_role ] = user_organization.organization_roles
    organization_role.role.name
  end
end
