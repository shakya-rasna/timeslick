defmodule DttRecharger.SchemaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DttRecharger.Schema` context.
  """

  @doc """
  Generate a stock_file.
  """
  def stock_file_fixture(attrs \\ %{}) do
    {:ok, stock_file} =
      attrs
      |> Enum.into(%{

      })
      |> DttRecharger.Schema.create_stock_file()

    stock_file
  end

  @doc """
  Generate a stock_item.
  """
  def stock_item_fixture(attrs \\ %{}) do
    {:ok, stock_item} =
      attrs
      |> Enum.into(%{
        activation_pin: "some activation_pin",
        active: true,
        denomination: "some denomination",
        expiry_date: ~N[2023-04-22 08:18:00],
        product_name: "some product_name",
        recharge_number: "some recharge_number"
      })
      |> DttRecharger.Schema.create_stock_item()

    stock_item
  end
end
