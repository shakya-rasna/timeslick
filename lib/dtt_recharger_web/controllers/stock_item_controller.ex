defmodule DttRechargerWeb.StockItemController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.StockItemOperation
  alias DttRecharger.Schema.StockItem

  def index(conn, _params) do
    stock_items = StockItemOperation.list_stock_items()
    render(conn, :index, stock_items: stock_items)
  end

  def new(conn, _params) do
    changeset = StockItemOperation.change_stock_item(%StockItem{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"stock_item" => stock_item_params}) do
    case StockItemOperation.create_stock_item(stock_item_params) do
      {:ok, stock_item} ->
        conn
        |> put_flash(:info, "Stock item created successfully.")
        |> redirect(to: ~p"/stock_items/#{stock_item}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stock_item = StockItemOperation.get_stock_item!(id)
    render(conn, :show, stock_item: stock_item)
  end

  def edit(conn, %{"id" => id}) do
    stock_item = StockItemOperation.get_stock_item!(id)
    changeset = StockItemOperation.change_stock_item(stock_item)
    render(conn, :edit, stock_item: stock_item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "stock_item" => stock_item_params}) do
    stock_item = StockItemOperation.get_stock_item!(id)

    case StockItemOperation.update_stock_item(stock_item, stock_item_params) do
      {:ok, stock_item} ->
        conn
        |> put_flash(:info, "Stock item updated successfully.")
        |> redirect(to: ~p"/stock_items/#{stock_item}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, stock_item: stock_item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    stock_item = StockItemOperation.get_stock_item!(id)
    {:ok, _stock_item} = StockItemOperation.delete_stock_item(stock_item)

    conn
    |> put_flash(:info, "Stock item deleted successfully.")
    |> redirect(to: ~p"/stock_items")
  end
end
