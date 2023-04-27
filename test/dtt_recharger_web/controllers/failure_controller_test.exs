defmodule DttRechargerWeb.FailureControllerTest do
  use DttRechargerWeb.ConnCase

  import DttRecharger.FailuresFixtures

  @create_attrs %{error_message: "some error_message", status: "some status"}
  @update_attrs %{error_message: "some updated error_message", status: "some updated status"}
  @invalid_attrs %{error_message: nil, status: nil}

  describe "index" do
    test "lists all failures", %{conn: conn} do
      conn = get(conn, ~p"/failures")
      assert html_response(conn, 200) =~ "Listing Failures"
    end
  end

  describe "new failure" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/failures/new")
      assert html_response(conn, 200) =~ "New Failure"
    end
  end

  describe "create failure" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/failures", failure: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/failures/#{id}"

      conn = get(conn, ~p"/failures/#{id}")
      assert html_response(conn, 200) =~ "Failure #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/failures", failure: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Failure"
    end
  end

  describe "edit failure" do
    setup [:create_failure]

    test "renders form for editing chosen failure", %{conn: conn, failure: failure} do
      conn = get(conn, ~p"/failures/#{failure}/edit")
      assert html_response(conn, 200) =~ "Edit Failure"
    end
  end

  describe "update failure" do
    setup [:create_failure]

    test "redirects when data is valid", %{conn: conn, failure: failure} do
      conn = put(conn, ~p"/failures/#{failure}", failure: @update_attrs)
      assert redirected_to(conn) == ~p"/failures/#{failure}"

      conn = get(conn, ~p"/failures/#{failure}")
      assert html_response(conn, 200) =~ "some updated error_message"
    end

    test "renders errors when data is invalid", %{conn: conn, failure: failure} do
      conn = put(conn, ~p"/failures/#{failure}", failure: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Failure"
    end
  end

  describe "delete failure" do
    setup [:create_failure]

    test "deletes chosen failure", %{conn: conn, failure: failure} do
      conn = delete(conn, ~p"/failures/#{failure}")
      assert redirected_to(conn) == ~p"/failures"

      assert_error_sent 404, fn ->
        get(conn, ~p"/failures/#{failure}")
      end
    end
  end

  defp create_failure(_) do
    failure = failure_fixture()
    %{failure: failure}
  end
end
