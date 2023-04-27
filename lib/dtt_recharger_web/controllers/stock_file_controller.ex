defmodule DttRechargerWeb.StockFileController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{StockFileOperation}
  alias DttRecharger.Schema.StockFile
  alias DttRecharger.Policies.StockFilePolicy
  alias DttRecharger.Helpers.RenderHelper

  def index(conn, _params) do
    if StockFilePolicy.index(conn.assigns.current_user_role) do
      stock_files = StockFileOperation.list_stock_files()
      render(conn, :index, stock_files: stock_files)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def new(conn, _params) do
    if StockFilePolicy.new(conn.assigns.current_user_role) do
      changeset = StockFileOperation.change_stock_file(%StockFile{})
      render(conn, :new, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def create(conn, %{"stock_file" => stock_file_params}) do
    if StockFilePolicy.create(conn.assigns.current_user_role) do
      case StockFileOperation.create_stock_file(stock_file_params) do
        {:ok, stock_file} ->
          conn
          |> put_flash(:info, "Stock file created successfully.")
          |> redirect(to: ~p"/stock_files/#{stock_file}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :new, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def show(conn, %{"id" => id}) do
    if StockFilePolicy.show(conn.assigns.current_user_role) do
      stock_file = StockFileOperation.get_stock_file!(id)
      render(conn, :show, stock_file: stock_file)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def edit(conn, %{"id" => id}) do
    if StockFilePolicy.edit(conn.assigns.current_user_role) do
      stock_file = StockFileOperation.get_stock_file!(id)
      changeset = StockFileOperation.change_stock_file(stock_file)
      render(conn, :edit, stock_file: stock_file, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def update(conn, %{"id" => id, "stock_file" => stock_file_params}) do
    if StockFilePolicy.update(conn.assigns.current_user_role) do
      stock_file = StockFileOperation.get_stock_file!(id)

      case StockFileOperation.update_stock_file(stock_file, stock_file_params) do
        {:ok, stock_file} ->
          conn
          |> put_flash(:info, "Stock file updated successfully.")
          |> redirect(to: ~p"/stock_files/#{stock_file}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :edit, stock_file: stock_file, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def delete(conn, %{"id" => id}) do
    if StockFilePolicy.delete(conn.assigns.current_user_role) do
      stock_file = StockFileOperation.get_stock_file!(id)
        {:ok, _stock_file} = StockFileOperation.delete_stock_file(stock_file)

        conn
        |> put_flash(:info, "Stock file deleted successfully.")
        |> redirect(to: ~p"/stock_files")
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end
end
