defmodule DttRecharger.DeliveriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DttRecharger.Deliveries` context.
  """

  @doc """
  Generate a delivery.
  """
  def delivery_fixture(attrs \\ %{}) do
    {:ok, delivery} =
      attrs
      |> Enum.into(%{
        delivery_date: ~N[2023-04-24 14:54:00],
        status: "some status"
      })
      |> DttRecharger.Deliveries.create_delivery()

    delivery
  end
end
