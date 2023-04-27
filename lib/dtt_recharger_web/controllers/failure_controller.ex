defmodule DttRechargerWeb.FailureController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.FailureOperation
  alias DttRecharger.Schema.Failure

  def index(conn, _params) do
    failures = FailureOperation.list_failures()
    render(conn, :index, failures: failures)
  end

  def new(conn, _params) do
    changeset = FailureOperation.change_failure(%Failure{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"failure" => failure_params}) do
    case FailureOperation.create_failure(failure_params) do
      {:ok, failure} ->
        conn
        |> put_flash(:info, "Failure created successfully.")
        |> redirect(to: ~p"/failures/#{failure}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    failure = FailureOperation.get_failure!(id)
    render(conn, :show, failure: failure)
  end

  def edit(conn, %{"id" => id}) do
    failure = FailureOperation.get_failure!(id)
    changeset = FailureOperation.change_failure(failure)
    render(conn, :edit, failure: failure, changeset: changeset)
  end

  def update(conn, %{"id" => id, "failure" => failure_params}) do
    failure = FailureOperation.get_failure!(id)

    case FailureOperation.update_failure(failure, failure_params) do
      {:ok, failure} ->
        conn
        |> put_flash(:info, "Failure updated successfully.")
        |> redirect(to: ~p"/failures/#{failure}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, failure: failure, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    failure = FailureOperation.get_failure!(id)
    {:ok, _failure} = FailureOperation.delete_failure(failure)

    conn
    |> put_flash(:info, "Failure deleted successfully.")
    |> redirect(to: ~p"/failures")
  end
end
