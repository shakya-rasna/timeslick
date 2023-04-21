defmodule DttRecharger.RecordOperationTest do
  use DttRecharger.DataCase

  alias DttRecharger.Operation.RecordOPeration

  describe "records" do
    alias DttRecharger.Schema.Record

    import DttRecharger.PaymentsFixtures

    @invalid_attrs %{amount: nil, contract_number: nil, entity_name: nil, id_number: nil, initials: nil, mobile_number: nil, product_name: nil, quantity: nil, surname: nil}

    test "list_records/0 returns all records" do
      record = record_fixture()
      assert Payments.list_records() == [record]
    end

    test "get_record!/1 returns the record with given id" do
      record = record_fixture()
      assert Payments.get_record!(record.id) == record
    end

    test "create_record/1 with valid data creates a record" do
      valid_attrs = %{amount: "some amount", contract_number: "some contract_number", entity_name: "some entity_name", id_number: "some id_number", initials: "some initials", mobile_number: "some mobile_number", product_name: "some product_name", quantity: 42, surname: "some surname"}

      assert {:ok, %Record{} = record} = Payments.create_record(valid_attrs)
      assert record.amount == "some amount"
      assert record.contract_number == "some contract_number"
      assert record.entity_name == "some entity_name"
      assert record.id_number == "some id_number"
      assert record.initials == "some initials"
      assert record.mobile_number == "some mobile_number"
      assert record.product_name == "some product_name"
      assert record.quantity == 42
      assert record.surname == "some surname"
    end

    test "create_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_record(@invalid_attrs)
    end

    test "update_record/2 with valid data updates the record" do
      record = record_fixture()
      update_attrs = %{amount: "some updated amount", contract_number: "some updated contract_number", entity_name: "some updated entity_name", id_number: "some updated id_number", initials: "some updated initials", mobile_number: "some updated mobile_number", product_name: "some updated product_name", quantity: 43, surname: "some updated surname"}

      assert {:ok, %Record{} = record} = Payments.update_record(record, update_attrs)
      assert record.amount == "some updated amount"
      assert record.contract_number == "some updated contract_number"
      assert record.entity_name == "some updated entity_name"
      assert record.id_number == "some updated id_number"
      assert record.initials == "some updated initials"
      assert record.mobile_number == "some updated mobile_number"
      assert record.product_name == "some updated product_name"
      assert record.quantity == 43
      assert record.surname == "some updated surname"
    end

    test "update_record/2 with invalid data returns error changeset" do
      record = record_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_record(record, @invalid_attrs)
      assert record == Payments.get_record!(record.id)
    end

    test "delete_record/1 deletes the record" do
      record = record_fixture()
      assert {:ok, %Record{}} = Payments.delete_record(record)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_record!(record.id) end
    end

    test "change_record/1 returns a record changeset" do
      record = record_fixture()
      assert %Ecto.Changeset{} = Payments.change_record(record)
    end
  end
end
