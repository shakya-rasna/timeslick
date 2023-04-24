defmodule DttRechargerWeb.OrderFileController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.OrderFileOperation
  alias DttRecharger.Schema.OrderFile

  def index(conn, _params) do
    order_files = OrderFileOperation.list_order_files()
    render(conn, :index, order_files: order_files)
  end

  def new(conn, _params) do
    changeset = OrderFileOperation.change_orderfile(%OrderFile{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"order_file" => order_file_params}) do
    case OrderFileOperation.create_order_file(order_file_params) do
      {:ok, order_file} ->
        conn
        |> put_flash(:info, "Order file created successfully.")
        |> redirect(to: ~p"/order_files/#{order_file}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order_file = OrderFileOperation.get_order_file!(id)
    render(conn, :show, order_file: order_file)
  end

  def edit(conn, %{"id" => id}) do
    order_file = OrderFileOperation.get_order_file!(id)
    changeset = OrderFileOperation.change_orderfile(order_file)
    render(conn, :edit, order_file: order_file, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order_file" => order_file_params}) do
    order_file = OrderFileOperation.get_order_file!(id)

    case OrderFileOperation.update_order_file(order_file, order_file_params) do
      {:ok, order_file} ->
        conn
        |> put_flash(:info, "Order file updated successfully.")
        |> redirect(to: ~p"/order_files/#{order_file}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, order_file: order_file, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order_file = OrderFileOperation.get_order_file!(id)
    {:ok, _order_file} = OrderFileOperation.delete_order_file(order_file)

    conn
    |> put_flash(:info, "Order file deleted successfully.")
    |> redirect(to: ~p"/order_files")
  end
end
