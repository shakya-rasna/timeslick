defmodule DttRecharger.Operations.AdminOperation do
  @moduledoc """
  The Organizations context.
  """
  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{User, Role, UserRole}

  @doc """
  Returns the list of admins.

  ## Examples

      iex> list_admins()
      [%User{}, ...]

  """
  def list_admins do
    role_id = Repo.get_by(Role, name: "admin").id
    from(u in User,
      left_join: ur in UserRole,
      on: u.id == ur.user_id,
      where: ur.role_id == ^role_id) |> Repo.all
  end

  @doc """
  Gets a single admin.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_admin!(123)
      %User{}

      iex> get_admin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_admin!(id), do: Repo.get!(User, id)

  def create_admin(attrs \\ %{}) do
    # org_params = Enum.map(Repo.all(Organization), fn organization ->
    #                %{organization_id: organization.id,
    #                  role_id: Repo.get_by(Role, %{name: "admin"}).id} end)
    # attrs = Map.put(attrs, "organization_roles", org_params)
    attrs = Map.put(attrs, "user_role", %{role_id: Repo.get_by(Role, name: "admin").id})
    %User{}
    |> User.admin_registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a admin.

  ## Examples

      iex> update_admin(admin, %{field: new_value})
      {:ok, %User{}}

      iex> update_admin(admin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_admin(%User{} = admin, attrs) do
    admin
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a admin.

  ## Examples

      iex> delete_admin(admin)
      {:ok, %User{}}

      iex> delete_admin(admin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_admin(%User{} = admin) do
    Repo.delete(admin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking admin changes.

  ## Examples

      iex> change_admin(admin)
      %Ecto.Changeset{data: %User{}}

  """
  def change_admin(%User{} = admin, attrs \\ %{}) do
    User.changeset(admin, attrs)
  end
end
