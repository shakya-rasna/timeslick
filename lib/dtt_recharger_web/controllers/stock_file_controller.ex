defmodule DttRechargerWeb.StockFileController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{StockFileOperation, StockItemOperation}
  alias DttRecharger.Schema.StockFile

  def index(conn, _params) do
    stock_files = StockFileOperation.list_stock_files()
    render(conn, :index, stock_files: stock_files)
  end

  def new(conn, _params) do
    changeset = StockFileOperation.change_stock_file(%StockFile{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"stock_file" => stock_file_params}) do
    case StockFileOperation.create_stock_file(stock_file_params) do
      {:ok, stock_file} ->
        conn
        |> put_flash(:info, "Stock file created successfully.")
        |> redirect(to: ~p"/stock_files/#{stock_file}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stock_file = StockFileOperation.get_stock_file!(id)
    render(conn, :show, stock_file: stock_file)
  end

  def edit(conn, %{"id" => id}) do
    stock_file = StockFileOperation.get_stock_file!(id)
    changeset = StockFileOperation.change_stock_file(stock_file)
    render(conn, :edit, stock_file: stock_file, changeset: changeset)
  end

  def update(conn, %{"id" => id, "stock_file" => stock_file_params}) do
    stock_file = StockFileOperation.get_stock_file!(id)

    case StockFileOperation.update_stock_file(stock_file, stock_file_params) do
      {:ok, stock_file} ->
        conn
        |> put_flash(:info, "Stock file updated successfully.")
        |> redirect(to: ~p"/stock_files/#{stock_file}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, stock_file: stock_file, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    stock_file = StockFileOperation.get_stock_file!(id)
    {:ok, _stock_file} = StockFileOperation.delete_stock_file(stock_file)

    conn
    |> put_flash(:info, "Stock file deleted successfully.")
    |> redirect(to: ~p"/stock_files")
  end
end
