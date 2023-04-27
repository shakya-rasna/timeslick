defmodule DttRecharger.Operations.AdminOperation do
  @moduledoc """
  The Organizations context.
  """
  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Operations.AccountOperation
  alias DttRecharger.Schema.{User, Role, OrganizationRole, Organization, UserNotifier}

  @doc """
  Returns the list of admins.

  ## Examples

      iex> list_admins()
      [%User{}, ...]

  """
  def list_admins do
    role_id = Repo.get_by(Role, name: "admin").id
    from(u in User,
      left_join: ro in OrganizationRole,
      on: u.id == ro.user_id,
      where: ro.role_id == ^role_id) |> Repo.all
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

  @doc """
  Creates a admin.

  ## Examples

      iex> create_admin(%{field: value})
      {:ok, %User{}}

      iex> create_admin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_admin(attrs \\ %{}) do
    org_params = Enum.map(Repo.all(Organization), fn organization ->
                   %{organization_id: organization.id,
                     role_id: Repo.get_by(Role, %{name: "admin"}).id} end)
    attrs = Map.put(attrs, "organization_roles", org_params)
    case AccountOperation.get_user_by_email(attrs["email"]) do
      nil ->
        {:ok, user} = %User{}
                      |> User.changeset(attrs)
                      |> Repo.insert()
        UserNotifier.deliver_admin_invitations(user, attrs["password"])
      user ->
        user
        |> Repo.preload([:organization_role])
        |> User.changeset(attrs)
        |> Repo.update()
        UserNotifier.deliver_admin_invitations(user)
    end
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
