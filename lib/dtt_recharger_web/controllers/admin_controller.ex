defmodule DttRechargerWeb.AdminController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Schema.User
  alias DttRecharger.Operations.AdminOperation

  def index(conn, _params) do
    admins = AdminOperation.list_admins()
    render(conn, :index, admins: admins)
  end

  def new(conn, _params) do
    changeset = AdminOperation.change_admin(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => admin_params}) do
    case AdminOperation.create_admin(admin_params) do
      {:ok, _admin} ->
        conn
        |> put_flash(:info, "Admin created successfully.")
        |> redirect(to: ~p"/admins")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    admin = AdminOperation.get_admin!(id)
    render(conn, :show, admin: admin)
  end

  def edit(conn, %{"id" => id}) do
    admin = AdminOperation.get_admin!(id)
    changeset = AdminOperation.change_admin(admin)
    render(conn, :edit, admin: admin, changeset: changeset)
  end

  def update(conn, %{"id" => id, "admin" => admin_params}) do
    admin = AdminOperation.get_admin!(id)

    case AdminOperation.update_admin(admin, admin_params) do
      {:ok, admin} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/admins/#{admin}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, admin: admin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    admin = AdminOperation.get_admin!(id)
    {:ok, _admin} = AdminOperation.delete_admin(admin)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/admins")
  end
end
