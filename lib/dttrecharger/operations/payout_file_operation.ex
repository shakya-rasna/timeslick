defmodule DTTRecharger.Operations.PayoutFileOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  alias DTTRecharger.Repo
  require IEx

  alias DTTRecharger.Schema.PayoutFile

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payout changes.

  ## Examples

      iex> change_payoutfile(payoutfile)
      %Ecto.Changeset{data: %PayoutFile{}}

  """
  def change_payoutfile(%PayoutFile{} = payout_file, attrs \\ %{}) do
    PayoutFile.changeset(payout_file, attrs)
  end

  def convert_params(data) do
    data
    |> Enum.map(fn payout_datas ->
      payout_datas
      |> Enum.map(fn payout_data -> payout_data end)
      |> Enum.map(fn {key, value} -> {key, value} end)
      |> Enum.into(%{})
      |> convert()
    end)
  end

  def convert(data) do
    for {key, val} <- data, into: %{}, do: {String.to_atom(key), val}
  end

  def parse_fields(payout_data) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)
    payout_data
      |> Map.put("inserted_at", timestamp)
      |> Map.put("updated_at", timestamp)
  end

  def insert_payout_datas(payout_datas) do
    PayoutFile
    |> Repo.insert_all(payout_datas,
      on_conflict: :nothing,
      returning: true
    )
  end
end
