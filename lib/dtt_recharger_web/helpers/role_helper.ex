defmodule DttRechargerWeb.Helpers.RoleHelper do
  alias DttRecharger.Operations.OrganizationRoleOperation
  def user_org_role(user, org_id) do
    OrganizationRoleOperation.get_user_org_role_name(user, org_id)
  end
end
