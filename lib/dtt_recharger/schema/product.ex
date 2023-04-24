defmodule DttRecharger.Schema.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :validity_in_days, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :validity_in_days])
    |> validate_required([:name, :validity_in_days])
    |> unsafe_validate_unique(:name, DttRecharger.Repo)
  end
end
