defmodule DttRechargerWeb.OrderFileController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.OrderFileOperation
  alias DttRecharger.Schema.OrderFile
  alias DttRecharger.Policies.OrderFilePolicy
  alias DttRecharger.Helpers.RenderHelper

  def index(conn, _params) do
    if OrderFilePolicy.index(conn.assigns.current_user_role) do
      order_files = if conn.assigns.current_user_role == "user", do: OrderFileOperation.list_organization_order_files(conn.assigns.current_organization.id), else: OrderFileOperation.list_order_files()
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

  def authorize_payouts(conn, %{"order_file_id" => order_file_id}) do
    current_user = conn.assigns[:current_user]
    current_role = conn.assigns[:current_user_role]
    case OrderFileOperation.get_order_file!(order_file_id) do
      nil ->
        conn
        |> put_flash(:error, "Payouts are not valid")
        |> redirect(to: ~p"/order_files")

      order_file ->
        cond do
          current_role == "user" && order_file.uploader_id == current_user.id ->
            conn
            |> put_flash(:error, "You are not allowed to authorize your own uploads")
            |> redirect(to: ~p"/order_files")

          !is_nil(order_file.authorized_at) && order_file.authorize_status == "authorized" ->
            conn
            |> put_flash(:error, "Payouts has already been authorized")
            |> redirect(to: ~p"/order_files")

          is_nil(order_file.authorized_at) && is_nil(order_file.authorize_status) ->
            case OrderFileOperation.authorize_payouts(order_file, current_user) do
              {:ok, _order_file} ->
                conn
                |> put_flash(:info, "You have successfully authorized payout file.")
                |> redirect(to: ~p"/order_files")

              {:error, %Ecto.Changeset{} = _changeset} ->
                conn
                |> put_flash(:error, "Something went wrong.")
                |> redirect(to: ~p"/order_files")
            end
        end
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
