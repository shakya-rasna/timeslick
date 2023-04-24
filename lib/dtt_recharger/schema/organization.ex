defmodule DttRecharger.Schema.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unsafe_validate_unique(:name, DttRecharger.Repo)
    |> unique_constraint(:name)
  end
end
