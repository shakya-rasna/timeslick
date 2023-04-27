defmodule DttRecharger.ScheduleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DttRecharger.Schedule` context.
  """

  @doc """
  Generate a schedule.
  """
  def schedule_fixture(attrs \\ %{}) do
    {:ok, schedule} =
      attrs
      |> Enum.into(%{
        delivered_date: ~N[2023-04-26 05:47:00],
        delivery_date: ~N[2023-04-26 05:47:00],
        queued_date: ~N[2023-04-26 05:47:00],
        status: "some status"
      })
      |> DttRecharger.Schedule.create_schedule()

    schedule
  end
end
