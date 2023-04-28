defmodule DttRecharger.Operations.UserOperation do

  @moduledoc """
  The Schema context.
  """

  import Ecto.Query, warn: false
  alias DttRecharger.Operations.AccountOperation
  alias DttRecharger.Repo

  alias DttRecharger.Schema.{User, Role, OrganizationRole, UserRole, Organization}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    role = Repo.get_by(Role, name: "user")
    from(u in User,
      left_join: ur in UserRole,
      on: ur.user_id == u.id,
      where: ur.role_id == ^role.id,
      preload: [:role, :organizations]) |> Repo.all
  end

  @doc """
  Returns the list of organization's users.
  """

  def organization_users(organization_id) do
    roles_id = from(r in Role, where: r.name != "superadmin" and r.name != "admin", select: r.id) |> Repo.all
    from(u in User,
      join: ou in OrganizationRole,
      on: u.id == ou.user_id,
      where: ou.organization_id == ^organization_id and ou.role_id in ^roles_id) |> Repo.all
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the Stock file does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    case Repo.get(User, id) do
      nil -> nil
      user -> Repo.preload(user, [:role, :organizations])
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    user_params = Map.put(attrs, "user_role", %{role_id: Repo.get_by(Role, name: "user").id})
    org_role_params = List.first(Enum.map(attrs["organization_roles"], fn {_key, val} -> val end))
    case AccountOperation.get_user_by_email(attrs["email"]) do
      nil ->
        {:ok, user} = %User{}
                       |> User.user_registration_changeset(user_params)
                       |> Repo.insert()
        AccountOperation.deliver_user_invitations(user, Repo.get(Organization,org_role_params["organization_id"]), attrs["password"])
      user ->
        OrganizationRole.changeset(%OrganizationRole{}, Map.put(org_role_params, "user_id", user.id))
        |> Repo.insert
        AccountOperation.deliver_user_invitations(user, Repo.get(Organization,org_role_params["organization_id"]))
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> Repo.preload([:user_role])
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
