defmodule Timeslick.PaymentsTest do
  use Timeslick.DataCase

  alias Timeslick.Payments

  describe "payouts" do
    alias Timeslick.Payments.Payout

    import Timeslick.PaymentsFixtures

    @invalid_attrs %{amount: nil, contract_number: nil, entity_name: nil, id_number: nil, initials: nil, mobile_number: nil, product_name: nil, quantity: nil, surname: nil}

    test "list_payouts/0 returns all payouts" do
      payout = payout_fixture()
      assert Payments.list_payouts() == [payout]
    end

    test "get_payout!/1 returns the payout with given id" do
      payout = payout_fixture()
      assert Payments.get_payout!(payout.id) == payout
    end

    test "create_payout/1 with valid data creates a payout" do
      valid_attrs = %{amount: "some amount", contract_number: "some contract_number", entity_name: "some entity_name", id_number: "some id_number", initials: "some initials", mobile_number: "some mobile_number", product_name: "some product_name", quantity: 42, surname: "some surname"}

      assert {:ok, %Payout{} = payout} = Payments.create_payout(valid_attrs)
      assert payout.amount == "some amount"
      assert payout.contract_number == "some contract_number"
      assert payout.entity_name == "some entity_name"
      assert payout.id_number == "some id_number"
      assert payout.initials == "some initials"
      assert payout.mobile_number == "some mobile_number"
      assert payout.product_name == "some product_name"
      assert payout.quantity == 42
      assert payout.surname == "some surname"
    end

    test "create_payout/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payout(@invalid_attrs)
    end

    test "update_payout/2 with valid data updates the payout" do
      payout = payout_fixture()
      update_attrs = %{amount: "some updated amount", contract_number: "some updated contract_number", entity_name: "some updated entity_name", id_number: "some updated id_number", initials: "some updated initials", mobile_number: "some updated mobile_number", product_name: "some updated product_name", quantity: 43, surname: "some updated surname"}

      assert {:ok, %Payout{} = payout} = Payments.update_payout(payout, update_attrs)
      assert payout.amount == "some updated amount"
      assert payout.contract_number == "some updated contract_number"
      assert payout.entity_name == "some updated entity_name"
      assert payout.id_number == "some updated id_number"
      assert payout.initials == "some updated initials"
      assert payout.mobile_number == "some updated mobile_number"
      assert payout.product_name == "some updated product_name"
      assert payout.quantity == 43
      assert payout.surname == "some updated surname"
    end

    test "update_payout/2 with invalid data returns error changeset" do
      payout = payout_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payout(payout, @invalid_attrs)
      assert payout == Payments.get_payout!(payout.id)
    end

    test "delete_payout/1 deletes the payout" do
      payout = payout_fixture()
      assert {:ok, %Payout{}} = Payments.delete_payout(payout)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payout!(payout.id) end
    end

    test "change_payout/1 returns a payout changeset" do
      payout = payout_fixture()
      assert %Ecto.Changeset{} = Payments.change_payout(payout)
    end
  end
end
