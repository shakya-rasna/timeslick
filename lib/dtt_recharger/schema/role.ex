defmodule DttRecharger.Schema.Role do
  use Ecto.Schema
  import Ecto.Changeset


  schema "roles" do
    field :name, :string

    has_one :user_role, UserRole, on_delete: :delete_all
    has_one :user, through: [:user_role, :user]

    timestamps()
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
