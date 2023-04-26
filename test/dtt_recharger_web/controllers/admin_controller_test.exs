defmodule DttRechargerWeb.AdminControllerTest do
  use DttRechargerWeb.ConnCase

  import DttRecharger.AdminsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all admins", %{conn: conn} do
      conn = get(conn, ~p"/admins")
      assert html_response(conn, 200) =~ "Listing Admins"
    end
  end

  describe "new admin" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/admins/new")
      assert html_response(conn, 200) =~ "New Admin"
    end
  end

  describe "create admin" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/admins", admin: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/admins/#{id}"

      conn = get(conn, ~p"/admins/#{id}")
      assert html_response(conn, 200) =~ "Admin #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/admins", admin: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Admin"
    end
  end

  describe "edit admin" do
    setup [:create_admin]

    test "renders form for editing chosen admin", %{conn: conn, admin: admin} do
      conn = get(conn, ~p"/admins/#{admin}/edit")
      assert html_response(conn, 200) =~ "Edit Admin"
    end
  end

  describe "update admin" do
    setup [:create_admin]

    test "redirects when data is valid", %{conn: conn, admin: admin} do
      conn = put(conn, ~p"/admins/#{admin}", admin: @update_attrs)
      assert redirected_to(conn) == ~p"/admins/#{admin}"

      conn = get(conn, ~p"/admins/#{admin}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, admin: admin} do
      conn = put(conn, ~p"/admins/#{admin}", admin: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Admin"
    end
  end

  describe "delete admin" do
    setup [:create_admin]

    test "deletes chosen admin", %{conn: conn, admin: admin} do
      conn = delete(conn, ~p"/admins/#{admin}")
      assert redirected_to(conn) == ~p"/admins"

      assert_error_sent 404, fn ->
        get(conn, ~p"/admins/#{admin}")
      end
    end
  end

  defp create_admin(_) do
    admin = admin_fixture()
    %{admin: admin}
  end
end
