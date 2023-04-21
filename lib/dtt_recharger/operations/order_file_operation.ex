defmodule DttRecharger.Operations.OrderFileOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  import DttRecharger.Helpers.StringParser

  alias DttRecharger.Repo
  alias DttRecharger.Schema.OrderFile

  def convert_params(data) do
    datas = data
    |> Enum.map(fn order_record_datas ->
      order_record_datas
      |> Enum.map(fn order_record_data -> order_record_data end)
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
    Returns an `%Ecto.Changeset{}` for tracking order_record changes.

    ## Examples

        iex> change_orderfile(orderfile)
        %Ecto.Changeset{data: %OrderFile{}}

    """
    def change_orderfile(%OrderFile{} = order_record_file, attrs \\ %{}) do
      OrderFile.changeset(order_record_file, attrs)
    end
  end
