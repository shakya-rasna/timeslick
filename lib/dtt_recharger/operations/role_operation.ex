defmodule DttRecharger.Operations.RoleOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{Role}

    def list_role do
      from(r in Role, where: r.name != "superadmin") |> Repo.all
    end
  end
