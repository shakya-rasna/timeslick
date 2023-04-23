defmodule DttRechargerWeb.UserController do
defmodule(DefaultPassword, do: use(RandomPassword))
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{UserOperation, RoleOperation}
  alias DttRecharger.Schema.{User, UserRole}

  def index(conn, _params) do
    users = UserOperation.list_users()
    render(conn, :index, users: users)
  end

  def new(conn, _params) do
    changeset = UserOperation.change_user(%User{user_role: %UserRole{}})
    roles = RoleOperation.list_role()
    render(conn, :new, roles: roles, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    password = DefaultPassword.generate()
    case UserOperation.create_user(Map.put(user_params, "password", password)) do
      {:ok, user} ->
        {:ok, _} = AccountOperation.deliver_user_invitations(user, password)
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        roles = RoleOperation.list_role()
        render(conn, :new, changeset: changeset, roles: roles)
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserOperation.get_user!(id)
    render(conn, :show, user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = UserOperation.get_user!(id)
    changeset = UserOperation.change_user(user)
    roles = RoleOperation.list_role()
    render(conn, :edit, user: user, changeset: changeset, roles: roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserOperation.get_user!(id)

    case UserOperation.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        roles = RoleOperation.list_role()
        render(conn, :edit, user: user, changeset: changeset, roles: roles)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserOperation.get_user!(id)
    {:ok, _user} = UserOperation.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end
end
