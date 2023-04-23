defmodule DttRechargerWeb.StockItemControllerTest do
  use DttRechargerWeb.ConnCase

  import DttRecharger.SchemaFixtures

  @create_attrs %{activation_pin: "some activation_pin", active: true, denomination: "some denomination", expiry_date: ~N[2023-04-22 08:18:00], product_name: "some product_name", recharge_number: "some recharge_number"}
  @update_attrs %{activation_pin: "some updated activation_pin", active: false, denomination: "some updated denomination", expiry_date: ~N[2023-04-23 08:18:00], product_name: "some updated product_name", recharge_number: "some updated recharge_number"}
  @invalid_attrs %{activation_pin: nil, active: nil, denomination: nil, expiry_date: nil, product_name: nil, recharge_number: nil}

  describe "index" do
    test "lists all stock_items", %{conn: conn} do
      conn = get(conn, ~p"/stock_items")
      assert html_response(conn, 200) =~ "Listing Stock items"
    end
  end

  describe "new stock_item" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/stock_items/new")
      assert html_response(conn, 200) =~ "New Stock item"
    end
  end

  describe "create stock_item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/stock_items", stock_item: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/stock_items/#{id}"

      conn = get(conn, ~p"/stock_items/#{id}")
      assert html_response(conn, 200) =~ "Stock item #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/stock_items", stock_item: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Stock item"
    end
  end

  describe "edit stock_item" do
    setup [:create_stock_item]

    test "renders form for editing chosen stock_item", %{conn: conn, stock_item: stock_item} do
      conn = get(conn, ~p"/stock_items/#{stock_item}/edit")
      assert html_response(conn, 200) =~ "Edit Stock item"
    end
  end

  describe "update stock_item" do
    setup [:create_stock_item]

    test "redirects when data is valid", %{conn: conn, stock_item: stock_item} do
      conn = put(conn, ~p"/stock_items/#{stock_item}", stock_item: @update_attrs)
      assert redirected_to(conn) == ~p"/stock_items/#{stock_item}"

      conn = get(conn, ~p"/stock_items/#{stock_item}")
      assert html_response(conn, 200) =~ "some updated activation_pin"
    end

    test "renders errors when data is invalid", %{conn: conn, stock_item: stock_item} do
      conn = put(conn, ~p"/stock_items/#{stock_item}", stock_item: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Stock item"
    end
  end

  describe "delete stock_item" do
    setup [:create_stock_item]

    test "deletes chosen stock_item", %{conn: conn, stock_item: stock_item} do
      conn = delete(conn, ~p"/stock_items/#{stock_item}")
      assert redirected_to(conn) == ~p"/stock_items"

      assert_error_sent 404, fn ->
        get(conn, ~p"/stock_items/#{stock_item}")
      end
    end
  end

  defp create_stock_item(_) do
    stock_item = stock_item_fixture()
    %{stock_item: stock_item}
  end
end
