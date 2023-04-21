defmodule DttRecharger.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DttRecharger.Payments` context.
  """

  @doc """
  Generate a payout.
  """
  def payout_fixture(attrs \\ %{}) do
    {:ok, payout} =
      attrs
      |> Enum.into(%{
        amount: "some amount",
        contract_number: "some contract_number",
        entity_name: "some entity_name",
        id_number: "some id_number",
        initials: "some initials",
        mobile_number: "some mobile_number",
        product_name: "some product_name",
        quantity: 42,
        surname: "some surname"
      })
      |> DttRecharger.Payments.create_payout()

    payout
  end
end
