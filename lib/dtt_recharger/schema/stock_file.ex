defmodule DttRecharger.Schema.StockFile do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.{UploadFile, StockItem}
  require IEx

  schema "stock_files" do

    belongs_to :upload_file, UploadFile, foreign_key: :upload_file_id
    has_many :stock_items, StockItem, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(stock_file, attrs) do
    IEx.pry
    stock_file
    |> cast(attrs, [:upload_file_id])
    |> assoc_constraint(:upload_file)
    |> validate_required([:upload_file_id])
  end
end
