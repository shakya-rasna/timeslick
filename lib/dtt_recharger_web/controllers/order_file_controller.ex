defmodule DttRechargerWeb.OrderFileController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.OrderFileOperation
  alias DttRecharger.Schema.OrderFile
  alias DttRecharger.Policies.OrderFilePolicy
  alias DttRecharger.Helpers.RenderHelper

  def index(conn, _params) do
    if OrderFilePolicy.index(conn.assigns.current_user_role) do
      order_files = if conn.assigns.current_user_role == "uploader", do: OrderFileOperation.list_organization_order_files(conn.assigns.current_organization.id), else: OrderFileOperation.list_order_files()
      render(conn, :index, order_files: order_files)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def new(conn, _params) do
    if OrderFilePolicy.new(conn.assigns.current_user_role) do
      changeset = OrderFileOperation.change_orderfile(%OrderFile{})
      render(conn, :new, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def create(conn, %{"order_file" => order_file_params}) do
    if OrderFilePolicy.create(conn.assigns.current_user_role) do
      case OrderFileOperation.create_order_file(order_file_params) do
        {:ok, order_file} ->
          conn
          |> put_flash(:info, "Order file created successfully.")
          |> redirect(to: ~p"/order_files/#{order_file}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :new, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def show(conn, %{"id" => id}) do
    if OrderFilePolicy.show(conn.assigns.current_user_role) do
      order_file = OrderFileOperation.get_order_file!(id)
      render(conn, :show, order_file: order_file)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def edit(conn, %{"id" => id}) do
    if OrderFilePolicy.edit(conn.assigns.current_user_role) do
      order_file = OrderFileOperation.get_order_file!(id)
      changeset = OrderFileOperation.change_orderfile(order_file)
      render(conn, :edit, order_file: order_file, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def update(conn, %{"id" => id, "order_file" => order_file_params}) do
    if OrderFilePolicy.update(conn.assigns.current_user_role) do
      order_file = OrderFileOperation.get_order_file!(id)

      case OrderFileOperation.update_order_file(order_file, order_file_params) do
        {:ok, order_file} ->
          conn
          |> put_flash(:info, "Order file updated successfully.")
          |> redirect(to: ~p"/order_files/#{order_file}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :edit, order_file: order_file, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def delete(conn, %{"id" => id}) do
    if OrderFilePolicy.delete(conn.assigns.current_user_role) do
      order_file = OrderFileOperation.get_order_file!(id)
      {:ok, _order_file} = OrderFileOperation.delete_order_file(order_file)

      conn
      |> put_flash(:info, "Order file deleted successfully.")
      |> redirect(to: ~p"/order_files")
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end
end
