defmodule DttRechargerWeb.OrganizationController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.OrganizationOperation
  alias DttRecharger.Schema.Organization
  alias DttRecharger.Policies.OrganizationPolicy
  alias DttRecharger.Helpers.RenderHelper

  def index(conn, _params) do
    if OrganizationPolicy.index(conn.assigns.current_user_role) do
      render(conn, :index, organizations: OrganizationOperation.list_organizations())
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def new(conn, _params) do
    if OrganizationPolicy.new(conn.assigns.current_user_role) do
      render(conn, :new, changeset: OrganizationOperation.change_organization(%Organization{}))
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def create(conn, %{"organization" => organization_params}) do
    if OrganizationPolicy.create(conn.assigns.current_user_role) do
      case OrganizationOperation.create_organization(organization_params) do
        {:ok, organization} ->
          conn
          |> put_flash(:info, "Organization created successfully.")
          |> redirect(to: ~p"/organizations/#{organization}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :new, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def show(conn, %{"id" => id}) do
    if OrganizationPolicy.create(conn.assigns.current_user_role) do
      organization = OrganizationOperation.get_organization!(id)
      render(conn, :show, organization: organization)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def my_organization(conn, _params) do
    org = conn.assigns.current_organization
    organization = OrganizationOperation.get_organization!(org.id)
    render(conn, :my_organization, organization: organization)
  end

  def edit(conn, %{"id" => id}) do
    if OrganizationPolicy.index(conn.assigns.current_user_role) do
      organization = OrganizationOperation.get_organization!(id)
      changeset = OrganizationOperation.change_organization(organization)
      render(conn, :edit, organization: organization, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    if OrganizationPolicy.index(conn.assigns.current_user_role) do
      organization = OrganizationOperation.get_organization!(id)

      case OrganizationOperation.update_organization(organization, organization_params) do
        {:ok, organization} ->
          conn
          |> put_flash(:info, "Organization updated successfully.")
          |> redirect(to: ~p"/organizations/#{organization}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :edit, organization: organization, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end

  end

  def delete(conn, %{"id" => id}) do
    if OrganizationPolicy.index(conn.assigns.current_user_role) do
      organization = OrganizationOperation.get_organization!(id)
      {:ok, _organization} = OrganizationOperation.delete_organization(organization)

      conn
      |> put_flash(:info, "Organization deleted successfully.")
      |> redirect(to: ~p"/organizations")
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end
end
