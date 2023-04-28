defmodule DttRechargerWeb.DeliveryController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.DeliveryOperation
  alias DttRecharger.Schema.Delivery
  alias DttRecharger.Policies.DeliveryPolicy
  alias DttRecharger.Helpers.RenderHelper

  def index(conn, _params) do
    if DeliveryPolicy.index(conn.assigns.current_user_role) do
      deliveries = if conn.assigns.current_user_role == "user", do: DeliveryOperation.list_organization_deliveries(conn.assigns.current_organization.id), else: DeliveryOperation.list_deliveries()
      render(conn, :index, deliveries: deliveries)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def new(conn, _params) do
    if DeliveryPolicy.new(conn.assigns.current_user_role) do
      changeset = DeliveryOperation.change_delivery(%Delivery{})
      render(conn, :new, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def create(conn, %{"delivery" => delivery_params}) do
    if DeliveryPolicy.create(conn.assigns.current_user_role) do
      case DeliveryOperation.create_delivery(delivery_params) do
        {:ok, delivery} ->
          conn
          |> put_flash(:info, "Delivery created successfully.")
          |> redirect(to: ~p"/deliveries/#{delivery}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :new, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def show(conn, %{"id" => id}) do
    if DeliveryPolicy.show(conn.assigns.current_user_role) do
      delivery = DeliveryOperation.get_delivery!(id)
      render(conn, :show, delivery: delivery)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def edit(conn, %{"id" => id}) do
    if DeliveryPolicy.edit(conn.assigns.current_user_role) do
      delivery = DeliveryOperation.get_delivery!(id)
      changeset = DeliveryOperation.change_delivery(delivery)
      render(conn, :edit, delivery: delivery, changeset: changeset)
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def update(conn, %{"id" => id, "delivery" => delivery_params}) do
    if DeliveryPolicy.update(conn.assigns.current_user_role) do
      delivery = DeliveryOperation.get_delivery!(id)

      case DeliveryOperation.update_delivery(delivery, delivery_params) do
        {:ok, delivery} ->
          conn
          |> put_flash(:info, "Delivery updated successfully.")
          |> redirect(to: ~p"/deliveries/#{delivery}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :edit, delivery: delivery, changeset: changeset)
      end
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end

  def delete(conn, %{"id" => id}) do
    if DeliveryPolicy.delete(conn.assigns.current_user_role) do
      delivery = DeliveryOperation.get_delivery!(id)
      {:ok, _delivery} = DeliveryOperation.delete_delivery(delivery)

      conn
      |> put_flash(:info, "Delivery deleted successfully.")
      |> redirect(to: ~p"/deliveries")
    else
      RenderHelper.render_error_default(conn, "Unauthorized")
    end
  end
end
