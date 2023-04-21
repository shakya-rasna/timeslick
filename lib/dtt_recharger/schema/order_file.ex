defmodule DttRecharger.Schema.OrderFile do
  use Ecto.Schema
  import Ecto.Changeset
  use  Waffle.Ecto.Schema

  schema "order_files" do
    field :file, DttRecharger.FileCsv.Type

    timestamps()
  end

  @doc false
  def changeset(order_file, attrs) do
    order_file
    |> cast(attrs, [])
    |> cast_attachments(attrs, [:file])
    |> validate_required([:file])
  end
end
