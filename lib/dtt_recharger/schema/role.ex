defmodule DttRecharger.Schema.Role do
  use Ecto.Schema
  import Ecto.Changeset


  schema "roles" do
    field :name, :string

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
