defmodule DttRecharger.Schema.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_roles" do
    belongs_to :user, DttRecharger.Schema.User
    belongs_to :role, DttRecharger.Schema.Role

    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:role)
    |> validate_required([:role_id])
  end
end
