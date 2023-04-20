defmodule DTTRechargerWeb.PayoutControllerTest do
  use DTTRechargerWeb.ConnCase

  import DTTRecharger.PaymentsFixtures

  @create_attrs %{amount: "some amount", contract_number: "some contract_number", entity_name: "some entity_name", id_number: "some id_number", initials: "some initials", mobile_number: "some mobile_number", product_name: "some product_name", quantity: 42, surname: "some surname"}
  @update_attrs %{amount: "some updated amount", contract_number: "some updated contract_number", entity_name: "some updated entity_name", id_number: "some updated id_number", initials: "some updated initials", mobile_number: "some updated mobile_number", product_name: "some updated product_name", quantity: 43, surname: "some updated surname"}
  @invalid_attrs %{amount: nil, contract_number: nil, entity_name: nil, id_number: nil, initials: nil, mobile_number: nil, product_name: nil, quantity: nil, surname: nil}

  describe "index" do
    test "lists all payouts", %{conn: conn} do
      conn = get(conn, ~p"/payouts")
      assert html_response(conn, 200) =~ "Listing Payouts"
    end
  end

  describe "new payout" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/payouts/new")
      assert html_response(conn, 200) =~ "New Payout"
    end
  end

  describe "create payout" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/payouts", payout: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/payouts/#{id}"

      conn = get(conn, ~p"/payouts/#{id}")
      assert html_response(conn, 200) =~ "Payout #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/payouts", payout: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Payout"
    end
  end

  describe "edit payout" do
    setup [:create_payout]

    test "renders form for editing chosen payout", %{conn: conn, payout: payout} do
      conn = get(conn, ~p"/payouts/#{payout}/edit")
      assert html_response(conn, 200) =~ "Edit Payout"
    end
  end

  describe "update payout" do
    setup [:create_payout]

    test "redirects when data is valid", %{conn: conn, payout: payout} do
      conn = put(conn, ~p"/payouts/#{payout}", payout: @update_attrs)
      assert redirected_to(conn) == ~p"/payouts/#{payout}"

      conn = get(conn, ~p"/payouts/#{payout}")
      assert html_response(conn, 200) =~ "some updated amount"
    end

    test "renders errors when data is invalid", %{conn: conn, payout: payout} do
      conn = put(conn, ~p"/payouts/#{payout}", payout: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Payout"
    end
  end

  describe "delete payout" do
    setup [:create_payout]

    test "deletes chosen payout", %{conn: conn, payout: payout} do
      conn = delete(conn, ~p"/payouts/#{payout}")
      assert redirected_to(conn) == ~p"/payouts"

      assert_error_sent 404, fn ->
        get(conn, ~p"/payouts/#{payout}")
      end
    end
  end

  defp create_payout(_) do
    payout = payout_fixture()
    %{payout: payout}
  end
end
