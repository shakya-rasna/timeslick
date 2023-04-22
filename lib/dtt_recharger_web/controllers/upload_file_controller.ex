defmodule DttRechargerWeb.UploadFileController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{RecordOperation, UploadFileOperation}
  alias DttRecharger.Schema.UploadFile

  def new_upload_file(conn, _params) do
    changeset = UploadFileOperation.change_uploadfile(%UploadFile{})
    render(conn, :new_upload_file, changeset: changeset)
  end

  def save_file_and_import_record(conn, %{"upload_file" => upload_file_params}) do
    data = csv_decoder(upload_file_params["file"])
    case import_order_record_data(data) do
      {:ok, _records} ->
        conn
          |> put_flash(:info, "Record has been imported successfully.")
          |> redirect(to: ~p"/records")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new_upload_file, changeset: changeset)
    end
  end

  def import_order_record_data(data) do
    with {:ok, params} <- UploadFileOperation.convert_params(data),
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
