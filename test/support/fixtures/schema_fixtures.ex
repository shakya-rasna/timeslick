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
end
