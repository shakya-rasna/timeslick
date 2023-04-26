defmodule DttRechargerWeb.AdminController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Schema.User
  alias DttRecharger.Operations.AdminOperation
  alias DttRecharger.Policies.AdminPolicy
  alias DttRecharger.Helpers.RenderHelper

  def index(conn, _params) do
    if AdminPolicy.index(conn.assigns.current_user_role) do
      admins = AdminOperation.list_admins()
      render(conn, :index, admins: admins)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def new(conn, _params) do
    if AdminPolicy.new(conn.assigns.current_user_role) do
      changeset = AdminOperation.change_admin(%User{})
      render(conn, :new, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def create(conn, %{"user" => admin_params}) do
    if AdminPolicy.create(conn.assigns.current_user_role) do
      case AdminOperation.create_admin(admin_params) do
        {:ok, _admin} ->
          conn
          |> put_flash(:info, "Admin created successfully.")
          |> redirect(to: ~p"/admins")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :new, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def show(conn, %{"id" => id}) do
    if AdminPolicy.show(conn.assigns.current_user_role) do
      admin = AdminOperation.get_admin!(id)
      render(conn, :show, admin: admin)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def edit(conn, %{"id" => id}) do
    if AdminPolicy.edit(conn.assigns.current_user_role) do
      admin = AdminOperation.get_admin!(id)
      changeset = AdminOperation.change_admin(admin)
      render(conn, :edit, admin: admin, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def update(conn, %{"id" => id, "admin" => admin_params}) do
    if AdminPolicy.update(conn.assigns.current_user_role) do
      admin = AdminOperation.get_admin!(id)

      case AdminOperation.update_admin(admin, admin_params) do
        {:ok, admin} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: ~p"/admins/#{admin}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :edit, admin: admin, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def delete(conn, %{"id" => id}) do
    if AdminPolicy.new(conn.assigns.current_user_role) do
      admin = AdminOperation.get_admin!(id)
      {:ok, _admin} = AdminOperation.delete_admin(admin)

      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: ~p"/admins")
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end
end
