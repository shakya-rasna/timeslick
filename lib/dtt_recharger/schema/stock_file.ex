defmodule DttRecharger.Schema.StockFile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stock_files" do

    field :upload_file_id, :id

    timestamps()
  end

  @doc false
  def changeset(stock_file, attrs) do
    stock_file
    |> cast(attrs, [])
    |> validate_required([])
  end
end
