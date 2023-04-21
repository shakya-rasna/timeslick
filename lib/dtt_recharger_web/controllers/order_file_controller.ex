defmodule DttRechargerWeb.OrderFileController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{RecordOperation, OrderFileOperation}
  alias DttRecharger.Schema.OrderFile

  def new_order_file(conn, _params) do
    changeset = OrderFileOperation.change_orderfile(%OrderFile{})
    render(conn, :new_record, changeset: changeset)
  end

  def import_order_record(conn, %{"order_file" => order_file_params}) do
    data = csv_decoder(order_file_params["file"])
    case import_order_record_data(data) do
      {:ok, _records} ->
        conn
          |> put_flash(:info, "Record has been imported successfully.")
          |> redirect(to: ~p"/records")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new_record, changeset: changeset)
    end
  end

  def import_order_record_data(data) do
    with {:ok, params} <- OrderFileOperation.convert_params(data),
         {:ok, records} <- RecordOperation.bulk_csv_import_records(params) do
      {:ok, records}
    end
  end

  defp csv_decoder(%Plug.Upload{path: path, content_type: _content_type, filename: _filename}) do
    path
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Enum.map(fn {:ok, data} -> data end)
  end
end
