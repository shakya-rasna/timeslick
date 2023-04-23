defmodule DttRecharger.Schema.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.{UserRole}

  schema "roles" do
    field :name, :string

    timestamps()

    has_many :user_roles, UserRole, on_replace: :delete, on_delete: :delete_all
    has_many :users, through: [:user_roles, :user]
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
