defmodule DttRecharger.SchemaTest do
  use DttRecharger.DataCase

  alias DttRecharger.Schema

  describe "stock_files" do
    alias DttRecharger.Schema.StockFile

    import DttRecharger.SchemaFixtures

    @invalid_attrs %{}

    test "list_stock_files/0 returns all stock_files" do
      stock_file = stock_file_fixture()
      assert Schema.list_stock_files() == [stock_file]
    end

    test "get_stock_file!/1 returns the stock_file with given id" do
      stock_file = stock_file_fixture()
      assert Schema.get_stock_file!(stock_file.id) == stock_file
    end

    test "create_stock_file/1 with valid data creates a stock_file" do
      valid_attrs = %{}

      assert {:ok, %StockFile{} = stock_file} = Schema.create_stock_file(valid_attrs)
    end

    test "create_stock_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_stock_file(@invalid_attrs)
    end

    test "update_stock_file/2 with valid data updates the stock_file" do
      stock_file = stock_file_fixture()
      update_attrs = %{}

      assert {:ok, %StockFile{} = stock_file} = Schema.update_stock_file(stock_file, update_attrs)
    end

    test "update_stock_file/2 with invalid data returns error changeset" do
      stock_file = stock_file_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_stock_file(stock_file, @invalid_attrs)
      assert stock_file == Schema.get_stock_file!(stock_file.id)
    end

    test "delete_stock_file/1 deletes the stock_file" do
      stock_file = stock_file_fixture()
      assert {:ok, %StockFile{}} = Schema.delete_stock_file(stock_file)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_stock_file!(stock_file.id) end
    end

    test "change_stock_file/1 returns a stock_file changeset" do
      stock_file = stock_file_fixture()
      assert %Ecto.Changeset{} = Schema.change_stock_file(stock_file)
    end
  end

  describe "stock_items" do
    alias DttRecharger.Schema.StockItem

    import DttRecharger.SchemaFixtures

    @invalid_attrs %{activation_pin: nil, active: nil, denomination: nil, expiry_date: nil, product_name: nil, recharge_number: nil}

    test "list_stock_items/0 returns all stock_items" do
      stock_item = stock_item_fixture()
      assert Schema.list_stock_items() == [stock_item]
    end

    test "get_stock_item!/1 returns the stock_item with given id" do
      stock_item = stock_item_fixture()
      assert Schema.get_stock_item!(stock_item.id) == stock_item
    end

    test "create_stock_item/1 with valid data creates a stock_item" do
      valid_attrs = %{activation_pin: "some activation_pin", active: true, denomination: "some denomination", expiry_date: ~N[2023-04-22 08:18:00], product_name: "some product_name", recharge_number: "some recharge_number"}

      assert {:ok, %StockItem{} = stock_item} = Schema.create_stock_item(valid_attrs)
      assert stock_item.activation_pin == "some activation_pin"
      assert stock_item.active == true
      assert stock_item.denomination == "some denomination"
      assert stock_item.expiry_date == ~N[2023-04-22 08:18:00]
      assert stock_item.product_name == "some product_name"
      assert stock_item.recharge_number == "some recharge_number"
    end

    test "create_stock_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_stock_item(@invalid_attrs)
    end

    test "update_stock_item/2 with valid data updates the stock_item" do
      stock_item = stock_item_fixture()
      update_attrs = %{activation_pin: "some updated activation_pin", active: false, denomination: "some updated denomination", expiry_date: ~N[2023-04-23 08:18:00], product_name: "some updated product_name", recharge_number: "some updated recharge_number"}

      assert {:ok, %StockItem{} = stock_item} = Schema.update_stock_item(stock_item, update_attrs)
      assert stock_item.activation_pin == "some updated activation_pin"
      assert stock_item.active == false
      assert stock_item.denomination == "some updated denomination"
      assert stock_item.expiry_date == ~N[2023-04-23 08:18:00]
      assert stock_item.product_name == "some updated product_name"
      assert stock_item.recharge_number == "some updated recharge_number"
    end

    test "update_stock_item/2 with invalid data returns error changeset" do
      stock_item = stock_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_stock_item(stock_item, @invalid_attrs)
      assert stock_item == Schema.get_stock_item!(stock_item.id)
    end

    test "delete_stock_item/1 deletes the stock_item" do
      stock_item = stock_item_fixture()
      assert {:ok, %StockItem{}} = Schema.delete_stock_item(stock_item)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_stock_item!(stock_item.id) end
    end

    test "change_stock_item/1 returns a stock_item changeset" do
      stock_item = stock_item_fixture()
      assert %Ecto.Changeset{} = Schema.change_stock_item(stock_item)
    end
  end
end
