defmodule DttRecharger.AdminsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DttRecharger.Admins` context.
  """

  @doc """
  Generate a admin.
  """
  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(%{

      })
      |> DttRecharger.Admins.create_admin()

    admin
  end
end
