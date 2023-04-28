defmodule DttRechargerWeb.UserController do
defmodule(DefaultPassword, do: use(RandomPassword))
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{UserOperation, RoleOperation, OrganizationOperation}
  alias DttRecharger.Schema.{User, OrganizationRole, Role, Organization}
  alias DttRecharger.Policies.UserPolicy
  alias DttRecharger.Helpers.RenderHelper

  def index(conn, _params) do
    if UserPolicy.index(conn.assigns.current_user_role) do
      users = UserOperation.list_users()
      render(conn, :index, users: users)
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def new(conn, _params) do
    if UserPolicy.new(conn.assigns.current_user_role) do
      changeset = UserOperation.change_user(%User{organization_roles: [%OrganizationRole{}]})
      organizations = OrganizationOperation.list_organizations()
      render(conn, :new, organizations: organizations, changeset: changeset)
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def create(conn, %{"user" => user_params}) do
    if UserPolicy.create(conn.assigns.current_user_role) do
      password = DefaultPassword.generate()
      user_params = Map.put(user_params, "password", password)
      case UserOperation.create_user(user_params) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: ~p"/users")

        {:error, %Ecto.Changeset{} = changeset} ->
          organizations = OrganizationOperation.list_organizations()
          render(conn, :new, organizations: organizations, changeset: changeset)
      end
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def show(conn, %{"id" => id}) do
    if UserPolicy.show(conn.assigns.current_user_role) do
      user = UserOperation.get_user!(id)
      render(conn, :show, user: user)
    else
       RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def edit(conn, %{"id" => id}) do
    if UserPolicy.edit(conn.assigns.current_user_role) do
      user = UserOperation.get_user!(id)
      changeset = UserOperation.change_user(user, [:organization_role])
      organizations = OrganizationOperation.list_organizations()
      render(conn, :edit, user: user, organizations: organizations, changeset: changeset)
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
          organizations = OrganizationOperation.list_organizations()
          render(conn, :edit, user: user, organizations: organizations, changeset: changeset)
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
