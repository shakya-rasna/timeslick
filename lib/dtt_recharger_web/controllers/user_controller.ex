defmodule DttRechargerWeb.UserController do
defmodule(DefaultPassword, do: use(RandomPassword))
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{UserOperation, RoleOperation}
  alias DttRecharger.Schema.{User, OrganizationRole}
  alias DttRecharger.Policies.UserPolicy
  alias DttRecharger.Helpers.RenderHelper
  def index(conn, _params) do
    if UserPolicy.index(conn.assigns.current_user_role) do
      current_organization = conn.assigns.current_organization
      users = UserOperation.organization_users(current_organization.id)
      render(conn, :index, users: users, current_organization: current_organization)
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def new(conn, _params) do
    if UserPolicy.new(conn.assigns.current_user_role) do
      changeset = UserOperation.change_user(%User{organization_roles: [%OrganizationRole{}]})
      roles = RoleOperation.list_role()
      render(conn, :new, roles: roles, changeset: changeset)
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def create(conn, %{"user" => user_params}) do
    if UserPolicy.create(conn.assigns.current_user_role) do
      password = DefaultPassword.generate()
      current_organization = conn.assigns.current_organization
      org_role_params = Enum.map(user_params["organization_roles"], fn {_key, value} -> value end)
                        |> Enum.map(fn org_role -> Map.put(org_role, "organization_id", current_organization.id) end)
      user_params = Map.put(user_params, "organization_roles", org_role_params)
      user_params = Map.put(user_params, "password", password)
      case UserOperation.create_user(user_params, current_organization) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: ~p"/users")

        {:error, %Ecto.Changeset{} = changeset} ->
          roles = RoleOperation.list_role()
          render(conn, :new, changeset: changeset, roles: roles)
      end
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def show(conn, %{"id" => id}) do
    if UserPolicy.show(conn.assigns.current_user_role) do
      user = UserOperation.get_user!(id)
      current_organization = conn.assigns.current_organization
      render(conn, :show, user: user, current_organization: current_organization)
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def edit(conn, %{"id" => id}) do
    if UserPolicy.edit(conn.assigns.current_user_role) do
      user = UserOperation.get_user!(id)
      changeset = UserOperation.change_user(user, [:organization_role])
      roles = RoleOperation.list_role()
      render(conn, :edit, user: user, changeset: changeset, roles: roles)
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    if UserPolicy.update(conn.assigns.current_user_role) do
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
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def delete(conn, %{"id" => id}) do
    if UserPolicy.delete(conn.assigns.current_user_role) do
      user = UserOperation.get_user!(id)
      {:ok, _user} = UserOperation.delete_user(user)

      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: ~p"/users")
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end
end
