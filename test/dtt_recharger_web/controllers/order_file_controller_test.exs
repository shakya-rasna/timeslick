defmodule DttRechargerWeb.OrderFileControllerTest do
  use DttRechargerWeb.ConnCase

  import DttRecharger.OrderFileOperationFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all order_files", %{conn: conn} do
      conn = get(conn, ~p"/order_files")
      assert html_response(conn, 200) =~ "Listing Order files"
    end
  end

  describe "new order_file" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/order_files/new")
      assert html_response(conn, 200) =~ "New Order file"
    end
  end

  describe "create order_file" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/order_files", order_file: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/order_files/#{id}"

      conn = get(conn, ~p"/order_files/#{id}")
      assert html_response(conn, 200) =~ "Order file #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/order_files", order_file: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Order file"
    end
  end

  describe "edit order_file" do
    setup [:create_order_file]

    test "renders form for editing chosen order_file", %{conn: conn, order_file: order_file} do
      conn = get(conn, ~p"/order_files/#{order_file}/edit")
      assert html_response(conn, 200) =~ "Edit Order file"
    end
  end

  describe "update order_file" do
    setup [:create_order_file]

    test "redirects when data is valid", %{conn: conn, order_file: order_file} do
      conn = put(conn, ~p"/order_files/#{order_file}", order_file: @update_attrs)
      assert redirected_to(conn) == ~p"/order_files/#{order_file}"

      conn = get(conn, ~p"/order_files/#{order_file}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, order_file: order_file} do
      conn = put(conn, ~p"/order_files/#{order_file}", order_file: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Order file"
    end
  end

  describe "delete order_file" do
    setup [:create_order_file]

    test "deletes chosen order_file", %{conn: conn, order_file: order_file} do
      conn = delete(conn, ~p"/order_files/#{order_file}")
      assert redirected_to(conn) == ~p"/order_files"

      assert_error_sent 404, fn ->
        get(conn, ~p"/order_files/#{order_file}")
      end
    end
  end

  defp create_order_file(_) do
    order_file = order_file_fixture()
    %{order_file: order_file}
  end
end
