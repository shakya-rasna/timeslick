defmodule DttRechargerWeb.DeliveryControllerTest do
  use DttRechargerWeb.ConnCase

  import DttRecharger.DeliveriesFixtures

  @create_attrs %{delivery_date: ~N[2023-04-24 14:54:00], status: "some status"}
  @update_attrs %{delivery_date: ~N[2023-04-25 14:54:00], status: "some updated status"}
  @invalid_attrs %{delivery_date: nil, status: nil}

  describe "index" do
    test "lists all deliveries", %{conn: conn} do
      conn = get(conn, ~p"/deliveries")
      assert html_response(conn, 200) =~ "Listing Deliveries"
    end
  end

  describe "new delivery" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/deliveries/new")
      assert html_response(conn, 200) =~ "New Delivery"
    end
  end

  describe "create delivery" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/deliveries", delivery: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/deliveries/#{id}"

      conn = get(conn, ~p"/deliveries/#{id}")
      assert html_response(conn, 200) =~ "Delivery #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/deliveries", delivery: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Delivery"
    end
  end

  describe "edit delivery" do
    setup [:create_delivery]

    test "renders form for editing chosen delivery", %{conn: conn, delivery: delivery} do
      conn = get(conn, ~p"/deliveries/#{delivery}/edit")
      assert html_response(conn, 200) =~ "Edit Delivery"
    end
  end

  describe "update delivery" do
    setup [:create_delivery]

    test "redirects when data is valid", %{conn: conn, delivery: delivery} do
      conn = put(conn, ~p"/deliveries/#{delivery}", delivery: @update_attrs)
      assert redirected_to(conn) == ~p"/deliveries/#{delivery}"

      conn = get(conn, ~p"/deliveries/#{delivery}")
      assert html_response(conn, 200) =~ "some updated status"
    end

    test "renders errors when data is invalid", %{conn: conn, delivery: delivery} do
      conn = put(conn, ~p"/deliveries/#{delivery}", delivery: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Delivery"
    end
  end

  describe "delete delivery" do
    setup [:create_delivery]

    test "deletes chosen delivery", %{conn: conn, delivery: delivery} do
      conn = delete(conn, ~p"/deliveries/#{delivery}")
      assert redirected_to(conn) == ~p"/deliveries"

      assert_error_sent 404, fn ->
        get(conn, ~p"/deliveries/#{delivery}")
      end
    end
  end

  defp create_delivery(_) do
    delivery = delivery_fixture()
    %{delivery: delivery}
  end
end
