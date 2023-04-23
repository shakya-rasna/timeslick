defmodule DttRecharger.Operations.UploadFileOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  import DttRecharger.Helpers.CsvParser

  alias Ecto.Multi
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{UploadFile, OrderFile}
  alias DttRecharger.Operations.{OrderFileOperation, RecordOperation}

  def save_file_and_import_orders(file_param) do
    %Plug.Upload{path: path, filename: filename, content_type: type} = file_param
    attrs = %{file: file_param, path: path, filename: filename, content_type: type, file_type: "order"}
    csv_parsed_datas = parse_csv(path, type)
    result = Multi.new()
             |> Multi.insert(:upload_file, UploadFile.changeset(%UploadFile{}, attrs))
             |> Multi.insert(:order_file,
                  fn %{upload_file: %UploadFile{id: upload_file_id}} ->
                    OrderFileOperation.change_orderfile(%OrderFile{}, %{upload_file_id: upload_file_id,
                                                                        total_records: length(csv_parsed_datas)}) end)
             |> Repo.transaction()
    case result do
      {:ok, info} ->
        record_attrs = Enum.map(csv_parsed_datas, fn data -> Map.put(data, :order_file_id, info[:order_file].id) end)
        case RecordOperation.bulk_csv_import_records(record_attrs) do
          {:ok, records} -> OrderFile.changeset(Repo.get(OrderFile, info[:order_file].id), %{processed_records: Enum.count(records)})
                            |> Repo.update
          {:error, changeset} -> {:error, changeset}
        end

      {:error, changeset} -> {:error, changeset}
    end
  end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking order_record changes.

    ## Examples

        iex> change_uploadfile(upload_file)
        %Ecto.Changeset{data: %UploadFile{}}
    """
    def change_uploadfile(%UploadFile{} = upload_file, attrs \\ %{}) do
      UploadFile.changeset(upload_file, attrs)
    end
  end
