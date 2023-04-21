defmodule DTTRecharger.Operations.PayoutFileOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  import Timeslick.Helpers.StringParser

  alias DTTRecharger.Repo
  alias DTTRecharger.Schema.PayoutFile

  def convert_params(data) do
    datas = data
    |> Enum.map(fn payout_datas ->
      payout_datas
      |> Enum.map(fn payout_data -> payout_data end)
      |> Enum.map(fn {key, value} -> {snakecase(key), value} end)
      |> Enum.into(%{})
      |> convert()
    end)
    {:ok, datas}
  end

  def convert(data) do
    for {key, val} <- data, into: %{}, do: {String.to_atom(key), val}
  end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking payout changes.

    ## Examples

        iex> change_payoutfile(payoutfile)
        %Ecto.Changeset{data: %PayoutFile{}}

    """
    def change_payoutfile(%PayoutFile{} = payout_file, attrs \\ %{}) do
      PayoutFile.changeset(payout_file, attrs)
    end
  end
