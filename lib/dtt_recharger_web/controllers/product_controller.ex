defmodule DttRechargerWeb.ProductController do
  use DttRechargerWeb, :controller

  import DttRecharger.Helpers.CsvParser
  alias DttRecharger.Operations.ProductOperation
  alias DttRecharger.Schema.Product
  alias DttRecharger.Policies.ProductPolicy

  def index(conn, _params) do
    if ProductPolicy.index(conn.assigns.current_user_role) do
      products = ProductOperation.list_products()
      render(conn, :index, products: products)
    else
      put_flash(conn, :error, "Unauthorized") |> redirect(to: ~p"/")
    end
  end

  def new(conn, _params) do
    if ProductPolicy.new(conn.assigns.current_user_role) do
      changeset = ProductOperation.change_product(%Product{})
      render(conn, :new, changeset: changeset)
    else
      put_flash(conn, :error, "Unauthorized") |> redirect(to: ~p"/")
    end
  end

  def create(conn, %{"product" => product_params}) do
    if ProductPolicy.create(conn.assigns.current_user_role) do
      %Plug.Upload{path: path, filename: _filename, content_type: type} = product_params["file"]
      csv_parsed_datas = parse_csv( path, type)
      case ProductOperation.bulk_csv_import_records(csv_parsed_datas) do
        {:ok, _products} ->
          conn
            |> put_flash(:info, "Product has been imported successfully.")
            |> redirect(to: ~p"/products")
        {:error, changeset} ->
          render(conn, :new, changeset: changeset)
      end
    else
      put_flash(conn, :error, "Unauthorized") |> redirect(to: ~p"/")
    end
  end

  def show(conn, %{"id" => id}) do
    if ProductPolicy.show(conn.assigns.current_user_role) do
      product = ProductOperation.get_product!(id)
      render(conn, :show, product: product)
    else
      put_flash(conn, :error, "Unauthorized") |> redirect(to: ~p"/")
    end
  end

  def edit(conn, %{"id" => id}) do
    if ProductPolicy.edit(conn.assigns.current_user_role) do
      product = ProductOperation.get_product!(id)
      changeset = ProductOperation.change_product(product)
      render(conn, :edit, product: product, changeset: changeset)
    else
      put_flash(conn, :error, "Unauthorized") |> redirect(to: ~p"/")
    end
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    if ProductPolicy.update(conn.assigns.current_user_role) do
      product = ProductOperation.get_product!(id)

      case ProductOperation.update_product(product, product_params) do
        {:ok, product} ->
          conn
          |> put_flash(:info, "Product updated successfully.")
          |> redirect(to: ~p"/products/#{product}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :edit, product: product, changeset: changeset)
      end
    else
      put_flash(conn, :error, "Unauthorized") |> redirect(to: ~p"/")
    end
  end

  def delete(conn, %{"id" => id}) do
    if ProductPolicy.delete(conn.assigns.current_user_role) do
      product = ProductOperation.get_product!(id)
      {:ok, _product} = ProductOperation.delete_product(product)

      conn
      |> put_flash(:info, "Product deleted successfully.")
      |> redirect(to: ~p"/products")
    else
      put_flash(conn, :error, "Unauthorized") |> redirect(to: ~p"/")
    end
  end
end
