defmodule DttRecharger.Schema.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :validity_in_days, :integer
    field :back_name, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :validity_in_days, :back_name])
    |> set_back_name
    |> validate_required([:name, :validity_in_days])
    |> unsafe_validate_unique(:name, DttRecharger.Repo)
  end

  def set_back_name(changeset) do
    if !is_nil(changeset.changes[:name]) do
      changed_name = String.downcase(String.trim(changeset.changes[:name]))
      put_change(changeset, :back_name, changed_name)
    else
      changeset
    end
  end
end
