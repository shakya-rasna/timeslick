defmodule DttRechargerWeb.UploadFileController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{UploadFileOperation}
  alias DttRecharger.Schema.UploadFile

  def new_order_file(conn, _params) do
    changeset = UploadFileOperation.change_uploadfile(%UploadFile{})
    render(conn, :new_order_file, changeset: changeset)
  end

  def new_stock_file(conn, _params) do
    changeset = UploadFileOperation.change_uploadfile(%UploadFile{})
    render(conn, :new_stock_file, changeset: changeset)
  end

  def save_file_and_import_record(conn, %{"upload_file" => upload_file_params}) do
    current_user = conn.assigns.current_user
    case UploadFileOperation.save_file_and_import_orders(upload_file_params["file"], current_user) do
      {:ok, _records} ->
        conn
          |> put_flash(:info, "Loan Payouts have been imported successfully.")
          |> redirect(to: ~p"/order_files")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new_order_file, changeset: changeset)
    end
  end

  def save_file_and_import_stock(conn, %{"upload_file" => upload_file_params}) do
    current_user = conn.assigns.current_user
    case UploadFileOperation.save_file_and_import_stocks(upload_file_params["file"], current_user) do
      {:ok, _records} ->
        conn
          |> put_flash(:info, "Stocks have been imported successfully.")
          |> redirect(to: ~p"/stock_files")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new_order_file, changeset: changeset)
    end
  end
end
