defmodule DttRechargerWeb.DeliveryController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.DeliveryOperation
  alias DttRecharger.Schema.Delivery

  def index(conn, _params) do
    deliveries = DeliveryOperation.list_deliveries()
    render(conn, :index, deliveries: deliveries)
  end

  def new(conn, _params) do
    changeset = DeliveryOperation.change_delivery(%Delivery{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"delivery" => delivery_params}) do
    case DeliveryOperation.create_delivery(delivery_params) do
      {:ok, delivery} ->
        conn
        |> put_flash(:info, "Delivery created successfully.")
        |> redirect(to: ~p"/deliveries/#{delivery}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    delivery = DeliveryOperation.get_delivery!(id)
    render(conn, :show, delivery: delivery)
  end

  def edit(conn, %{"id" => id}) do
    delivery = DeliveryOperation.get_delivery!(id)
    changeset = DeliveryOperation.change_delivery(delivery)
    render(conn, :edit, delivery: delivery, changeset: changeset)
  end

  def update(conn, %{"id" => id, "delivery" => delivery_params}) do
    delivery = DeliveryOperation.get_delivery!(id)

    case DeliveryOperation.update_delivery(delivery, delivery_params) do
      {:ok, delivery} ->
        conn
        |> put_flash(:info, "Delivery updated successfully.")
        |> redirect(to: ~p"/deliveries/#{delivery}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, delivery: delivery, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    delivery = DeliveryOperation.get_delivery!(id)
    {:ok, _delivery} = DeliveryOperation.delete_delivery(delivery)

    conn
    |> put_flash(:info, "Delivery deleted successfully.")
    |> redirect(to: ~p"/deliveries")
  end
end
