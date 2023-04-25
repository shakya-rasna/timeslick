defmodule DttRechargerWeb.RecordController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.RecordOperation
  alias DttRecharger.Schema.Record

  def index(conn, _params) do
    records = RecordOperation.list_records()
    render(conn, :index, records: records)
  end

  def list_loan_payouts(conn, %{"order_file_id" => order_file_id}) do
    records = RecordOperation.list_records_by_file(order_file_id)
    order_file = OrderFileOperation.get_order_file!(order_file_id)
    render(conn, :list_loan_payouts, records: records, order_file: order_file)
  end

  def new(conn, _params) do
    changeset = RecordOperation.change_record(%Record{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"record" => record_params}) do
    case RecordOperation.create_record(record_params) do
      {:ok, record} ->
        conn
        |> put_flash(:info, "Record created successfully.")
        |> redirect(to: ~p"/records/#{record}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    record = RecordOperation.get_record!(id)
    render(conn, :show, record: record)
  end

  def edit(conn, %{"id" => id}) do
    record = RecordOperation.get_record!(id)
    changeset = RecordOperation.change_record(record)
    render(conn, :edit, record: record, changeset: changeset)
  end

  def update(conn, %{"id" => id, "record" => record_params}) do
    record = RecordOperation.get_record!(id)

    case RecordOperation.update_record(record, record_params) do
      {:ok, record} ->
        conn
        |> put_flash(:info, "Record updated successfully.")
        |> redirect(to: ~p"/records/#{record}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, record: record, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    record = RecordOperation.get_record!(id)
    {:ok, _record} = RecordOperation.delete_record(record)

    conn
    |> put_flash(:info, "Record deleted successfully.")
    |> redirect(to: ~p"/records")
  end
end
