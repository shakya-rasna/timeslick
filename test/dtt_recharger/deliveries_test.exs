defmodule DttRecharger.DeliveriesTest do
  use DttRecharger.DataCase

  alias DttRecharger.Deliveries

  describe "deliveries" do
    alias DttRecharger.Deliveries.Delivery

    import DttRecharger.DeliveriesFixtures

    @invalid_attrs %{delivery_date: nil, status: nil}

    test "list_deliveries/0 returns all deliveries" do
      delivery = delivery_fixture()
      assert Deliveries.list_deliveries() == [delivery]
    end

    test "get_delivery!/1 returns the delivery with given id" do
      delivery = delivery_fixture()
      assert Deliveries.get_delivery!(delivery.id) == delivery
    end

    test "create_delivery/1 with valid data creates a delivery" do
      valid_attrs = %{delivery_date: ~N[2023-04-24 14:54:00], status: "some status"}

      assert {:ok, %Delivery{} = delivery} = Deliveries.create_delivery(valid_attrs)
      assert delivery.delivery_date == ~N[2023-04-24 14:54:00]
      assert delivery.status == "some status"
    end

    test "create_delivery/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Deliveries.create_delivery(@invalid_attrs)
    end

    test "update_delivery/2 with valid data updates the delivery" do
      delivery = delivery_fixture()
      update_attrs = %{delivery_date: ~N[2023-04-25 14:54:00], status: "some updated status"}

      assert {:ok, %Delivery{} = delivery} = Deliveries.update_delivery(delivery, update_attrs)
      assert delivery.delivery_date == ~N[2023-04-25 14:54:00]
      assert delivery.status == "some updated status"
    end

    test "update_delivery/2 with invalid data returns error changeset" do
      delivery = delivery_fixture()
      assert {:error, %Ecto.Changeset{}} = Deliveries.update_delivery(delivery, @invalid_attrs)
      assert delivery == Deliveries.get_delivery!(delivery.id)
    end

    test "delete_delivery/1 deletes the delivery" do
      delivery = delivery_fixture()
      assert {:ok, %Delivery{}} = Deliveries.delete_delivery(delivery)
      assert_raise Ecto.NoResultsError, fn -> Deliveries.get_delivery!(delivery.id) end
    end

    test "change_delivery/1 returns a delivery changeset" do
      delivery = delivery_fixture()
      assert %Ecto.Changeset{} = Deliveries.change_delivery(delivery)
    end
  end
end
