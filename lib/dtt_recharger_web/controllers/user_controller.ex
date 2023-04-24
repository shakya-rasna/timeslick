defmodule DttRechargerWeb.UserController do
defmodule(DefaultPassword, do: use(RandomPassword))
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{UserOperation, AccountOperation, RoleOperation, OrganizationOperation}
  alias DttRecharger.Schema.{User, UserRole, OrganizationRole}

  def index(conn, _params) do
    users = UserOperation.list_users()
    current_organization = conn.assigns.current_organization
    render(conn, :index, users: users, current_organization: current_organization)
  end

  def new(conn, _params) do
    changeset = UserOperation.change_user(%User{organization_roles: [%OrganizationRole{}]})
    roles = RoleOperation.list_role()
    render(conn, :new, roles: roles, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    password = DefaultPassword.generate()
    current_organization = conn.assigns.current_organization
    org_role_params = Enum.map(user_params["organization_roles"], fn {key, value} -> value end)
                      |> Enum.map(fn org_role -> Map.put(org_role, "organization_id", current_organization.id) end)
    user_params = Map.put(user_params, "organization_roles", org_role_params)
    user_params = Map.put(user_params, "password", password)
    case UserOperation.create_user(user_params, current_organization) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/users")

      {:error, %Ecto.Changeset{} = changeset} ->
        roles = RoleOperation.list_role()
        render(conn, :new, changeset: changeset, roles: roles)
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserOperation.get_user!(id)
    current_organization = conn.assigns.current_organization
    render(conn, :show, user: user, current_organization: current_organization)
  end

  def edit(conn, %{"id" => id}) do
    user = UserOperation.get_user!(id)
    changeset = UserOperation.change_user(Repo.preload(user, [:organization_role]))
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
