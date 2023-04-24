defmodule DttRechargerWeb.OrganizationControllerTest do
  use DttRechargerWeb.ConnCase

  import DttRecharger.OrganizationsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all organizations", %{conn: conn} do
      conn = get(conn, ~p"/organizations")
      assert html_response(conn, 200) =~ "Listing Organizations"
    end
  end

  describe "new organization" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/organizations/new")
      assert html_response(conn, 200) =~ "New Organization"
    end
  end

  describe "create organization" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/organizations", organization: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/organizations/#{id}"

      conn = get(conn, ~p"/organizations/#{id}")
      assert html_response(conn, 200) =~ "Organization #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/organizations", organization: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Organization"
    end
  end

  describe "edit organization" do
    setup [:create_organization]

    test "renders form for editing chosen organization", %{conn: conn, organization: organization} do
      conn = get(conn, ~p"/organizations/#{organization}/edit")
      assert html_response(conn, 200) =~ "Edit Organization"
    end
  end

  describe "update organization" do
    setup [:create_organization]

    test "redirects when data is valid", %{conn: conn, organization: organization} do
      conn = put(conn, ~p"/organizations/#{organization}", organization: @update_attrs)
      assert redirected_to(conn) == ~p"/organizations/#{organization}"

      conn = get(conn, ~p"/organizations/#{organization}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, organization: organization} do
      conn = put(conn, ~p"/organizations/#{organization}", organization: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Organization"
    end
  end

  describe "delete organization" do
    setup [:create_organization]

    test "deletes chosen organization", %{conn: conn, organization: organization} do
      conn = delete(conn, ~p"/organizations/#{organization}")
      assert redirected_to(conn) == ~p"/organizations"

      assert_error_sent 404, fn ->
        get(conn, ~p"/organizations/#{organization}")
      end
    end
  end

  defp create_organization(_) do
    organization = organization_fixture()
    %{organization: organization}
  end
end
