defmodule DttRecharger.Schema.StockFile do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.{UploadFile, StockItem, User}

  schema "stock_files" do

    belongs_to :upload_file, UploadFile, foreign_key: :upload_file_id
    has_many :stock_items, StockItem, on_replace: :delete
    belongs_to :uploader, User, foreign_key: :uploader_id

    timestamps()
  end

  @doc false
  def changeset(stock_file, attrs) do
    stock_file
    |> cast(attrs, [:upload_file_id, :uploader_id])
    |> assoc_constraint(:upload_file)
    |> assoc_constraint(:uploader)
    |> validate_required([:upload_file_id, :uploader_id])
  end
end
