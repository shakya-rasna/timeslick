defmodule DttRecharger.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DttRecharger.Organizations` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> DttRecharger.Organizations.create_organization()

    organization
  end
end
