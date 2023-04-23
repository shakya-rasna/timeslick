defmodule DttRecharger.Schema.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.{User, Role}

  schema "user_roles" do
    belongs_to :user, User
    belongs_to :role, Role

    timestamps()
  end

  @doc false
  def changeset(user_roles, attrs) do
    user_roles
    |> cast(attrs, [:role_id, :user_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:role)
  end
end
