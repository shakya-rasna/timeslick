defmodule DttRecharger.Operations.OrganizationRoleOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{OrganizationRole, Role, User}

  def get_user_org_role(user, org_id \\ nil) do
    query =
      from og in OrganizationRole,
        where: og.user_id == ^user.id and og.organization_id == ^org_id

    case Repo.one(query) do
      nil -> nil
      org_role -> org_role
    end
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

  def bulk_assign_org_to_admin(org) do
    user_role_ids = from(u in User, left_join: ou in OrganizationRole, on: ou.user_id == u.id,
      left_join: r in Role, on: ou.role_id == r.id, where: r.name in ["admin", "superadmin"], select: %{user_id: u.id, role_id: r.id}) |> Repo.all
    params = Enum.map(user_role_ids, fn %{user_id: uid, role_id: rid} ->
      %{user_id: uid, role_id: rid, organization_id: org.id}
    end)
    or_changesets = Enum.map(params, fn param -> OrganizationRole.changeset(%OrganizationRole{}, param) end)
    result = or_changesets
            |> Enum.with_index()
            |> Enum.reduce(Ecto.Multi.new(), fn ({changeset, index}, multi) ->
                Ecto.Multi.insert(multi, Integer.to_string(index), changeset)
              end)
            |> Repo.transaction
    case result do
      {:ok, ors } -> {:ok, ors}
      {:error, _, changeset, _ } -> {:error, changeset}
    end
  end

  def increase_signin_count(%OrganizationRole{} = org_role) do
    org_role
    |> OrganizationRole.sign_in_count_changeset(%{sign_in_count: org_role.sign_in_count + 1 })
    |> Repo.update()
  end
end
