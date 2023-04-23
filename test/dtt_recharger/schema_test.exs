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
end
