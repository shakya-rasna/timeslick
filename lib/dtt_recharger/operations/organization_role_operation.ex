defmodule DttRecharger.Operations.OrganizationRoleOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{OrganizationRole, Organization}

    def get_user_org_role(user, org_id) do
      query =
        from og in OrganizationRole,
          where: og.user_id == ^user.id and og.organization_id == ^org_id

      Repo.one(query)
    end
  end
