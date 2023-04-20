defmodule DTTRechargerWeb.PayoutController do
  use DTTRechargerWeb, :controller

  alias DTTRecharger.Operations.PayoutOperation
  alias DTTRecharger.Schema.Payout

  def index(conn, _params) do
    payouts = PayoutOperation.list_payouts()
    render(conn, :index, payouts: payouts)
  end

  def new(conn, _params) do
    changeset = PayoutOperation.change_payout(%Payout{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"payout" => payout_params}) do
    case PayoutOperation.create_payout(payout_params) do
      {:ok, payout} ->
        conn
        |> put_flash(:info, "Payout created successfully.")
        |> redirect(to: ~p"/payouts/#{payout}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    payout = PayoutOperation.get_payout!(id)
    render(conn, :show, payout: payout)
  end

  def edit(conn, %{"id" => id}) do
    payout = PayoutOperation.get_payout!(id)
    changeset = PayoutOperation.change_payout(payout)
    render(conn, :edit, payout: payout, changeset: changeset)
  end

  def update(conn, %{"id" => id, "payout" => payout_params}) do
    payout = PayoutOperation.get_payout!(id)

    case PayoutOperation.update_payout(payout, payout_params) do
      {:ok, payout} ->
        conn
        |> put_flash(:info, "Payout updated successfully.")
        |> redirect(to: ~p"/payouts/#{payout}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, payout: payout, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payout = PayoutOperation.get_payout!(id)
    {:ok, _payout} = PayoutOperation.delete_payout(payout)

    conn
    |> put_flash(:info, "Payout deleted successfully.")
    |> redirect(to: ~p"/payouts")
  end
end
