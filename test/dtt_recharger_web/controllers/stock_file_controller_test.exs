defmodule DttRechargerWeb.StockFileControllerTest do
  use DttRechargerWeb.ConnCase

  import DttRecharger.SchemaFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all stock_files", %{conn: conn} do
      conn = get(conn, ~p"/stock_files")
      assert html_response(conn, 200) =~ "Listing Stock files"
    end
  end

  describe "new stock_file" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/stock_files/new")
      assert html_response(conn, 200) =~ "New Stock file"
    end
  end

  describe "create stock_file" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/stock_files", stock_file: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/stock_files/#{id}"

      conn = get(conn, ~p"/stock_files/#{id}")
      assert html_response(conn, 200) =~ "Stock file #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/stock_files", stock_file: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Stock file"
    end
  end

  describe "edit stock_file" do
    setup [:create_stock_file]

    test "renders form for editing chosen stock_file", %{conn: conn, stock_file: stock_file} do
      conn = get(conn, ~p"/stock_files/#{stock_file}/edit")
      assert html_response(conn, 200) =~ "Edit Stock file"
    end
  end

  describe "update stock_file" do
    setup [:create_stock_file]

    test "redirects when data is valid", %{conn: conn, stock_file: stock_file} do
      conn = put(conn, ~p"/stock_files/#{stock_file}", stock_file: @update_attrs)
      assert redirected_to(conn) == ~p"/stock_files/#{stock_file}"

      conn = get(conn, ~p"/stock_files/#{stock_file}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, stock_file: stock_file} do
      conn = put(conn, ~p"/stock_files/#{stock_file}", stock_file: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Stock file"
    end
  end

  describe "delete stock_file" do
    setup [:create_stock_file]

    test "deletes chosen stock_file", %{conn: conn, stock_file: stock_file} do
      conn = delete(conn, ~p"/stock_files/#{stock_file}")
      assert redirected_to(conn) == ~p"/stock_files"

      assert_error_sent 404, fn ->
        get(conn, ~p"/stock_files/#{stock_file}")
      end
    end
  end

  defp create_stock_file(_) do
    stock_file = stock_file_fixture()
    %{stock_file: stock_file}
  end
end
