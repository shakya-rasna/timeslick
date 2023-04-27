defmodule DttRecharger.FailuresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DttRecharger.Failures` context.
  """

  @doc """
  Generate a failure.
  """
  def failure_fixture(attrs \\ %{}) do
    {:ok, failure} =
      attrs
      |> Enum.into(%{
        error_message: "some error_message",
        status: "some status"
      })
      |> DttRecharger.Failures.create_failure()

    failure
  end
end
