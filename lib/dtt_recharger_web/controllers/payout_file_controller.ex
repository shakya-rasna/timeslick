defmodule DttRechargerWeb.PayoutFileController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{PayoutOperation, PayoutFileOperation}
  alias DttRecharger.Schema.PayoutFile

  def new_payout(conn, _params) do
    changeset = PayoutFileOperation.change_payoutfile(%PayoutFile{})
    render(conn, :new_payout, changeset: changeset)
  end

  def import_payout(conn, %{"payout_file" => payout_file_params}) do
    data = csv_decoder(payout_file_params["file"])
    case import_payout_data(data) do
      {:ok, _payouts} ->
        conn
          |> put_flash(:info, "Payout has been imported successfully.")
          |> redirect(to: ~p"/payouts")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new_payout, changeset: changeset)
    end
  end

  def import_payout_data(data) do
    with {:ok, params} <- PayoutFileOperation.convert_params(data),
         {:ok, payouts} <- PayoutOperation.bulk_csv_import_payouts(params) do
      {:ok, payouts}
    end
  end

  defp csv_decoder(%Plug.Upload{path: path, content_type: _content_type, filename: _filename}) do
    path
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Enum.map(fn {:ok, data} -> data end)
  end
end
