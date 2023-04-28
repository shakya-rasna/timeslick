defmodule DttRecharger.Operations.UploadFileOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  import DttRecharger.Helpers.{CsvParser, DateParser}
  alias Ecto.Multi
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{UploadFile, OrderFile, StockFile}
  alias DttRecharger.Operations.{OrderFileOperation, RecordOperation, StockFileOperation, StockItemOperation}
  def save_file_and_import_orders(file_param, current_user, current_org) do
    %Plug.Upload{path: path, filename: filename, content_type: type} = file_param
    attrs = %{file: file_param, path: path, filename: filename, content_type: type, file_type: "order"}
    csv_parsed_datas = parse_csv(path, type)
    current_org_id = if is_nil(current_org), do: nil, else: current_org.id
    result = Multi.new()
             |> Multi.insert(:upload_file, UploadFile.changeset(%UploadFile{}, attrs))
             |> Multi.insert(:order_file,
                  fn %{upload_file: %UploadFile{id: upload_file_id}} ->
                    OrderFileOperation.change_orderfile(%OrderFile{}, %{upload_file_id: upload_file_id,
                                                                        total_records: length(csv_parsed_datas),
                                                                        uploader_id: current_user.id,
                                                                        organization_id: current_org_id}) end)
             |> Repo.transaction()
    case result do
      {:ok, info} ->
        record_attrs = Enum.map(csv_parsed_datas, fn data ->
          data = Map.put(data, :order_file_id, info[:order_file].id)
          data = if is_nil(current_org_id), do: data, else: Map.put(data, :organization_id, current_org_id)
        end)
        case RecordOperation.bulk_csv_import_records(record_attrs) do
          {:ok, records} -> {:ok, records}
          {:error, changeset} -> {:error, changeset}
        end

      {:error, changeset} -> {:error, changeset}
    end
  end

  def save_file_and_import_stocks(file_param, current_user) do
    %Plug.Upload{path: path, filename: filename, content_type: type} = file_param
    attrs = %{file: file_param, path: path, filename: filename, content_type: type, file_type: "stock"}
    csv_parsed_datas = parse_csv(path, type)
    result = Multi.new()
             |> Multi.insert(:upload_file, UploadFile.changeset(%UploadFile{}, attrs))
             |> Multi.insert(:stock_file,
                  fn %{upload_file: %UploadFile{id: upload_file_id}} ->
                    StockFileOperation.change_stock_file(%StockFile{}, %{upload_file_id: upload_file_id,
                                                                         uploader_id: current_user.id}) end)
             |> Repo.transaction()
    case result do
      {:ok, info} ->
        stock_attrs = Enum.map(csv_parsed_datas, fn data ->
          expiry_date = convert_string_to_date(data.voucher_expiry_date)
            Map.put(data, :expiry_date, expiry_date)
            |> Map.put(:stock_file_id, info[:stock_file].id)
          end)
        case StockItemOperation.bulk_csv_import_stocks(stock_attrs) do
          {:ok, stocks} -> {:ok, stocks}
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
