defmodule DttRechargerWeb.ScheduleController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.ScheduleOperation
  alias DttRecharger.Schema.Schedule

  def index(conn, _params) do
    schedules = ScheduleOperation.list_schedules()
    render(conn, :index, schedules: schedules)
  end

  def new(conn, _params) do
    changeset = ScheduleOperation.change_schedule(%Schedule{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"schedule" => schedule_params}) do
    case ScheduleOperation.create_schedule(schedule_params) do
      {:ok, schedule} ->
        conn
        |> put_flash(:info, "ScheduleOperation created successfully.")
        |> redirect(to: ~p"/schedules/#{schedule}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    schedule = ScheduleOperation.get_schedule!(id)
    render(conn, :show, schedule: schedule)
  end

  def edit(conn, %{"id" => id}) do
    schedule = ScheduleOperation.get_schedule!(id)
    changeset = ScheduleOperation.change_schedule(schedule)
    render(conn, :edit, schedule: schedule, changeset: changeset)
  end

  def update(conn, %{"id" => id, "schedule" => schedule_params}) do
    schedule = ScheduleOperation.get_schedule!(id)

    case ScheduleOperation.update_schedule(schedule, schedule_params) do
      {:ok, schedule} ->
        conn
        |> put_flash(:info, "Schedule updated successfully.")
        |> redirect(to: ~p"/schedules/#{schedule}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, schedule: schedule, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    schedule = ScheduleOperation.get_schedule!(id)
    {:ok, _schedule} = ScheduleOperation.delete_schedule(schedule)

    conn
    |> put_flash(:info, "Schedule deleted successfully.")
    |> redirect(to: ~p"/schedules")
  end
end
