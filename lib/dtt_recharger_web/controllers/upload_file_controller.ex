defmodule DttRechargerWeb.UploadFileController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{UploadFileOperation}
  alias DttRecharger.Schema.UploadFile

  def new_upload_file(conn, _params) do
    changeset = UploadFileOperation.change_uploadfile(%UploadFile{})
    render(conn, :new_upload_file, changeset: changeset)
  end

  def save_file_and_import_record(conn, %{"upload_file" => upload_file_params}) do
    case UploadFileOperation.save_file_and_import_orders(upload_file_params["file"]) do
      {:ok, _records} ->
        conn
          |> put_flash(:info, "Record has been imported successfully.")
          |> redirect(to: ~p"/records")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new_upload_file, changeset: changeset)
    end
  end
end
