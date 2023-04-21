defmodule DttRecharger.Schema.FileType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "file_types" do
    field :type, Ecto.Enum, values: [:stock, :order]

    timestamps()
  end

  @doc false
  def changeset(file_type, attrs) do
    file_type
    |> cast(attrs, [:type])
    |> validate_required([:type])
    |> unsafe_validate_unique(:type, DttRecharger.Repo)
    |> unique_constraint(:type)
    |> validate_inclusion(:type, [:stock, :order])
  end
end
