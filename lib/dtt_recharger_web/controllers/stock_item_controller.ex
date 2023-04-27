defmodule DttRechargerWeb.StockItemController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.StockItemOperation
  alias DttRecharger.Schema.StockItem
  alias DttRecharger.Policies.StockItemPolicy
  alias DttRecharger.Helpers.RenderHelper

  def index(conn, _params) do
    if StockItemPolicy.index(conn.assigns.current_user_role) do
      stock_items = StockItemOperation.list_stock_items()
      render(conn, :index, stock_items: stock_items)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def list_stocks(conn, %{"stock_file_id" => stock_file_id}) do
    if StockItemPolicy.list_stocks(conn.assigns.current_user_role) do
      stocks = StockItemOperation.list_stocks_by_file(stock_file_id)
      render(conn, :list_stocks, stock_items: stocks)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def new(conn, _params) do
    if StockItemPolicy.new(conn.assigns.current_user_role) do
      changeset = StockItemOperation.change_stock_item(%StockItem{})
      render(conn, :new, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def create(conn, %{"stock_item" => stock_item_params}) do
    if StockItemPolicy.create(conn.assigns.current_user_role) do
      case StockItemOperation.create_stock_item(stock_item_params) do
        {:ok, stock_item} ->
          conn
          |> put_flash(:info, "Stock item created successfully.")
          |> redirect(to: ~p"/stock_items/#{stock_item}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :new, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def show(conn, %{"id" => id}) do
    if StockItemPolicy.show(conn.assigns.current_user_role) do
      stock_item = StockItemOperation.get_stock_item!(id)
      render(conn, :show, stock_item: stock_item)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def edit(conn, %{"id" => id}) do
    if StockItemPolicy.edit(conn.assigns.current_user_role) do
      stock_item = StockItemOperation.get_stock_item!(id)
      changeset = StockItemOperation.change_stock_item(stock_item)
      render(conn, :edit, stock_item: stock_item, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def update(conn, %{"id" => id, "stock_item" => stock_item_params}) do
    if StockItemPolicy.update(conn.assigns.current_user_role) do
      stock_item = StockItemOperation.get_stock_item!(id)

      case StockItemOperation.update_stock_item(stock_item, stock_item_params) do
        {:ok, stock_item} ->
          conn
          |> put_flash(:info, "Stock item updated successfully.")
          |> redirect(to: ~p"/stock_items/#{stock_item}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :edit, stock_item: stock_item, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def delete(conn, %{"id" => id}) do
    if StockItemPolicy.delete(conn.assigns.current_user_role) do
      stock_item = StockItemOperation.get_stock_item!(id)
      {:ok, _stock_item} = StockItemOperation.delete_stock_item(stock_item)

      conn
      |> put_flash(:info, "Stock item deleted successfully.")
      |> redirect(to: ~p"/stock_items")
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end
end
