defmodule DttRechargerWeb.RecordControllerTest do
  use DttRechargerWeb.ConnCase

  import DttRecharger.RecordOperationFixtures

  @create_attrs %{amount: "some amount", contract_number: "some contract_number", entity_name: "some entity_name", id_number: "some id_number", initials: "some initials", mobile_number: "some mobile_number", product_name: "some product_name", quantity: 42, surname: "some surname"}
  @update_attrs %{amount: "some updated amount", contract_number: "some updated contract_number", entity_name: "some updated entity_name", id_number: "some updated id_number", initials: "some updated initials", mobile_number: "some updated mobile_number", product_name: "some updated product_name", quantity: 43, surname: "some updated surname"}
  @invalid_attrs %{amount: nil, contract_number: nil, entity_name: nil, id_number: nil, initials: nil, mobile_number: nil, product_name: nil, quantity: nil, surname: nil}

  describe "index" do
    test "lists all records", %{conn: conn} do
      conn = get(conn, ~p"/records")
      assert html_response(conn, 200) =~ "Listing Records"
    end
  end

  describe "new record" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/records/new")
      assert html_response(conn, 200) =~ "New Record"
    end
  end

  describe "create record" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/records", record: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/records/#{id}"

      conn = get(conn, ~p"/records/#{id}")
      assert html_response(conn, 200) =~ "Record #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/records", record: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Record"
    end
  end

  describe "edit record" do
    setup [:create_record]

    test "renders form for editing chosen record", %{conn: conn, record: record} do
      conn = get(conn, ~p"/records/#{record}/edit")
      assert html_response(conn, 200) =~ "Edit Record"
    end
  end

  describe "update record" do
    setup [:create_record]

    test "redirects when data is valid", %{conn: conn, record: record} do
      conn = put(conn, ~p"/records/#{record}", record: @update_attrs)
      assert redirected_to(conn) == ~p"/records/#{record}"

      conn = get(conn, ~p"/records/#{record}")
      assert html_response(conn, 200) =~ "some updated amount"
    end

    test "renders errors when data is invalid", %{conn: conn, record: record} do
      conn = put(conn, ~p"/records/#{record}", record: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Record"
    end
  end

  describe "delete record" do
    setup [:create_record]

    test "deletes chosen record", %{conn: conn, record: record} do
      conn = delete(conn, ~p"/records/#{record}")
      assert redirected_to(conn) == ~p"/records"

      assert_error_sent 404, fn ->
        get(conn, ~p"/records/#{record}")
      end
    end
  end

  defp create_record(_) do
    record = record_fixture()
    %{record: record}
  end
end
