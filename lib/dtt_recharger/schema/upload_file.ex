defmodule DttRecharger.Schema.UploadFile do
  use Ecto.Schema
  import Ecto.Changeset
  use  Waffle.Ecto.Schema

  alias DttRecharger.Schema.FileType
  alias DttRecharger.Operations.FileTypeOperation

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
    attrs = if is_nil(attrs[:file_type]), do: attrs, else: Map.put(attrs, :file_type_id, get_file_type_id(attrs[:file_type]))
    upload_file
    |> cast(attrs, [:file, :filename, :path, :content_type, :file_type_id])
    |> assoc_constraint(:file_type)
    |> validate_required([:file, :filename, :path, :content_type, :file_type_id])
  end

  defp get_file_type_id(file_type)  do
    case FileTypeOperation.get_file_type_by_type(file_type) do
      nil -> nil
      file_type -> file_type.id
    end
  end
end
