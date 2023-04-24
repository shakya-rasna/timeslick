defmodule DttRechargerWeb.OrganizationController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.OrganizationOperation
  alias DttRecharger.Schema.Organization

  def index(conn, _params) do
    organizations = OrganizationOperation.list_organizations()
    render(conn, :index, organizations: organizations)
  end

  def new(conn, _params) do
    changeset = OrganizationOperation.change_organization(%Organization{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"organization" => organization_params}) do
    case OrganizationOperation.create_organization(organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization created successfully.")
        |> redirect(to: ~p"/organizations/#{organization}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = OrganizationOperation.get_organization!(id)
    render(conn, :show, organization: organization)
  end

  def edit(conn, %{"id" => id}) do
    organization = OrganizationOperation.get_organization!(id)
    changeset = OrganizationOperation.change_organization(organization)
    render(conn, :edit, organization: organization, changeset: changeset)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = OrganizationOperation.get_organization!(id)

    case OrganizationOperation.update_organization(organization, organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization updated successfully.")
        |> redirect(to: ~p"/organizations/#{organization}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, organization: organization, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = OrganizationOperation.get_organization!(id)
    {:ok, _organization} = OrganizationOperation.delete_organization(organization)

    conn
    |> put_flash(:info, "Organization deleted successfully.")
    |> redirect(to: ~p"/organizations")
  end
end
