defmodule DttRecharger.ScheduleTest do
  use DttRecharger.DataCase

  alias DttRecharger.Schedule

  describe "schedules" do
    alias DttRecharger.Schedule.Schema.Schedule

    import DttRecharger.ScheduleFixtures

    @invalid_attrs %{delivered_date: nil, delivery_date: nil, queued_date: nil, status: nil}

    test "list_schedules/0 returns all schedules" do
      schedule = schedule_fixture()
      assert Schedule.list_schedules() == [schedule]
    end

    test "get_schedule!/1 returns the schedule with given id" do
      schedule = schedule_fixture()
      assert Schedule.get_schedule!(schedule.id) == schedule
    end

    test "create_schedule/1 with valid data creates a schedule" do
      valid_attrs = %{delivered_date: ~N[2023-04-26 05:47:00], delivery_date: ~N[2023-04-26 05:47:00], queued_date: ~N[2023-04-26 05:47:00], status: "some status"}

      assert {:ok, %Schedule{} = schedule} = Schedule.create_schedule(valid_attrs)
      assert schedule.delivered_date == ~N[2023-04-26 05:47:00]
      assert schedule.delivery_date == ~N[2023-04-26 05:47:00]
      assert schedule.queued_date == ~N[2023-04-26 05:47:00]
      assert schedule.status == "some status"
    end

    test "create_schedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedule.create_schedule(@invalid_attrs)
    end

    test "update_schedule/2 with valid data updates the schedule" do
      schedule = schedule_fixture()
      update_attrs = %{delivered_date: ~N[2023-04-27 05:47:00], delivery_date: ~N[2023-04-27 05:47:00], queued_date: ~N[2023-04-27 05:47:00], status: "some updated status"}

      assert {:ok, %Schedule{} = schedule} = Schedule.update_schedule(schedule, update_attrs)
      assert schedule.delivered_date == ~N[2023-04-27 05:47:00]
      assert schedule.delivery_date == ~N[2023-04-27 05:47:00]
      assert schedule.queued_date == ~N[2023-04-27 05:47:00]
      assert schedule.status == "some updated status"
    end

    test "update_schedule/2 with invalid data returns error changeset" do
      schedule = schedule_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedule.update_schedule(schedule, @invalid_attrs)
      assert schedule == Schedule.get_schedule!(schedule.id)
    end

    test "delete_schedule/1 deletes the schedule" do
      schedule = schedule_fixture()
      assert {:ok, %Schedule{}} = Schedule.delete_schedule(schedule)
      assert_raise Ecto.NoResultsError, fn -> Schedule.get_schedule!(schedule.id) end
    end

    test "change_schedule/1 returns a schedule changeset" do
      schedule = schedule_fixture()
      assert %Ecto.Changeset{} = Schedule.change_schedule(schedule)
    end
  end
end
