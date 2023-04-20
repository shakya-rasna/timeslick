defmodule TimeslickWeb.PayoutController do
  use TimeslickWeb, :controller

  alias Timeslick.Payments
  alias Timeslick.Payments.Payout
  alias Timeslick.Payments.PayoutFile
  require IEx

  def index(conn, _params) do
    payouts = Payments.list_payouts()
    render(conn, :index, payouts: payouts)
  end

  def new(conn, _params) do
    changeset = Payments.change_payout(%Payout{})
    render(conn, :new, changeset: changeset)
  end

  def new_payout(conn, _params) do
    changeset = Payments.change_payoutfile(%PayoutFile{})
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

  def import_payout(conn, %{"payout_file" => payout_file_params}) do
    IEx.pry
    data = csv_decoder(payout_file_params["file"])
    import_payout_data(data)
    conn
      |> put_flash(:info, "Payout has been imported successfully.")
      |> redirect(to: ~p"/payouts")
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

  def import_payout_data(data) do
    IEx.pry
    # cars = Enum.map(data, fn {:ok, car} -> parse(car) end)
    # params = Auto.convert_params(cars)
    # {_, _} = Auto.insert_cars(params)
  end

  def csv_decoder(file) do
    IEx.pry
    # csv = "#{file.path}"
    # |> Path.expand(__DIR__)
    # |> File.stream!()
    # |> CSV.decode(headers: true)
    # |> Enum.map(fn data -> data end)
  end

  # defp import_cars(data) do
  #     cars = Enum.map(data, fn {:ok, car} -> parse(car) end)
  #   params = Auto.convert_params(cars)
  #   {_, _} = Auto.insert_cars(params)
  # end

  # defp parse(car) do
  #   fields = Auto.parse_fields(car)
  # end
  # #=== INSERT ALL =====
  # def insert_cars(items) do
  #   Car
  #   |> Repo.insert_all(items,
  #     on_conflict: :nothing,
  #     returning: true
  #   )
  # end
end
