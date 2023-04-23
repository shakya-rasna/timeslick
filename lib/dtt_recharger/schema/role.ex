defmodule DttRecharger.Schema.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.User

  schema "roles" do
    field :name, :string

    timestamps()
    many_to_many :users, User, join_through: "users_roles", join_keys: [role_id: :id, user_id: :id]
  end

  @doc false
  def changeset(roles, attrs) do
    roles
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unsafe_validate_unique(:name, DttRecharger.Repo)
    |> unique_constraint(:name)
  end
end
