defmodule DttRechargerWeb.ProductController do
  use DttRechargerWeb, :controller

  import DttRecharger.Helpers.CsvParser
  alias DttRecharger.Operations.ProductOperation
  alias DttRecharger.Schema.Product

  def index(conn, _params) do
    products = ProductOperation.list_products()
    render(conn, :index, products: products)
  end

  def new(conn, _params) do
    changeset = ProductOperation.change_product(%Product{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    %Plug.Upload{path: path, filename: filename, content_type: type} = product_params["file"]
    csv_parsed_datas = parse_csv( path, type)
    case ProductOperation.bulk_csv_import_records(csv_parsed_datas) do
      {:ok, _products} ->
        conn
          |> put_flash(:info, "Product has been imported successfully.")
          |> redirect(to: ~p"/products")
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = ProductOperation.get_product!(id)
    render(conn, :show, product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = ProductOperation.get_product!(id)
    changeset = ProductOperation.change_product(product)
    render(conn, :edit, product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = ProductOperation.get_product!(id)

    case ProductOperation.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: ~p"/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = ProductOperation.get_product!(id)
    {:ok, _product} = ProductOperation.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: ~p"/products")
  end
end
