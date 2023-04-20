defmodule TimeslickWeb.PayoutController do
  use TimeslickWeb, :controller

  alias Timeslick.Payments
  alias Timeslick.Payments.Payout

  def index(conn, _params) do
    payouts = Payments.list_payouts()
    render(conn, :index, payouts: payouts)
  end

  def new(conn, _params) do
    changeset = Payments.change_payout(%Payout{})
    render(conn, :new, changeset: changeset)
  end

  def new_payout(conn, _params) do
    changeset = Payments.change_payout(%Payout{})
    render(conn, :new_payout, changeset: changeset)
  end

  def create(conn, %{"payout" => payout_params}) do
    case Payments.create_payout(payout_params) do
      {:ok, payout} ->
        conn
        |> put_flash(:info, "Payout created successfully.")
        |> redirect(to: ~p"/payouts/#{payout}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    payout = Payments.get_payout!(id)
    render(conn, :show, payout: payout)
  end

  def edit(conn, %{"id" => id}) do
    payout = Payments.get_payout!(id)
    changeset = Payments.change_payout(payout)
    render(conn, :edit, payout: payout, changeset: changeset)
  end

  def update(conn, %{"id" => id, "payout" => payout_params}) do
    payout = Payments.get_payout!(id)

    case Payments.update_payout(payout, payout_params) do
      {:ok, payout} ->
        conn
        |> put_flash(:info, "Payout updated successfully.")
        |> redirect(to: ~p"/payouts/#{payout}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, payout: payout, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payout = Payments.get_payout!(id)
    {:ok, _payout} = Payments.delete_payout(payout)

    conn
    |> put_flash(:info, "Payout deleted successfully.")
    |> redirect(to: ~p"/payouts")
  end
end
