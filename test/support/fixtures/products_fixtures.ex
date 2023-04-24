defmodule DttRecharger.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DttRecharger.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name",
        validity_in_days: 42
      })
      |> DttRecharger.Products.create_product()

    product
  end
end
