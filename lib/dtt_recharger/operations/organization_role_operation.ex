defmodule DttRecharger.Operations.OrganizationRoleOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{OrganizationRole}

  def get_user_org_role(user, org_id) do
    query =
      from og in OrganizationRole,
        where: og.user_id == ^user.id and og.organization_id == ^org_id,
        preload: [:role]

    Repo.one(query)
  end

  def get_user_org_role_name(user, org_id) do
    query =
      from og in OrganizationRole,
        where: og.user_id == ^user.id and og.organization_id == ^org_id,
        preload: [:role]

    case Repo.one(query) do
      nil -> nil
      org_role -> org_role.role.name
    end
  end

  def increase_signin_count(%OrganizationRole{} = org_role) do
    org_role
    |> OrganizationRole.sign_in_count_changeset(%{sign_in_count: org_role.sign_in_count + 1 })
    |> Repo.update()
  end
end
