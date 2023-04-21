defmodule DttRecharger.Schema.UploadFile do
  use Ecto.Schema
  import Ecto.Changeset
  use  Waffle.Ecto.Schema

  alias DttRecharger.Schema.FileType

  schema "upload_files" do
    field :content_type, :string
    field :file, DttRecharger.FileCsv.Type
    field :filename, :string
    field :path, :string

    belongs_to :file_type, FileType, foreign_key: :file_type_id

    timestamps()
  end

  @doc false
  def changeset(upload_file, attrs) do
    upload_file
    |> cast(attrs, [:file, :filename, :path, :content_type, :file_type_id])
    |> cast_attachments(attrs, [:file])
    |> assoc_constraint(:file_type)
    |> validate_required([:file, :filename, :path, :content_type, :file_type_id])
  end
end
