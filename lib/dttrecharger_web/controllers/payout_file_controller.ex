defmodule DTTRechargerWeb.PayoutFileController do
  use DTTRechargerWeb, :controller

  alias DTTRecharger.Operations.PayoutFileOperation
  alias DTTRecharger.Schema.PayoutFile
  require IEx

  def new_payout(conn, _params) do
    changeset = PayoutFileOperation.change_payoutfile(%PayoutFile{})
    render(conn, :new_payout, changeset: changeset)
  end

  def import_payout(conn, %{"payout_file" => payout_file_params}) do
    data = csv_decoder(payout_file_params["file"])
    import_payout_data(data)
    conn
      |> put_flash(:info, "Payout has been imported successfully.")
      |> redirect(to: ~p"/payouts")
  end

  def import_payout_data(data) do
    payout_datas = Enum.map(data, fn {:ok, payout_data} -> parse(payout_data) end)
    params = PayoutFileOperation.convert_params(payout_datas)
    {_, _} = PayoutFileOperation.insert_payout_datas(payout_datas)
  end

  def csv_decoder(file) do
    csv = "#{file.path}"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Enum.map(fn data -> data end)
  end

  defp parse(payout_data) do
    fields = PayoutFileOperation.parse_fields(payout_data)
  end
end
