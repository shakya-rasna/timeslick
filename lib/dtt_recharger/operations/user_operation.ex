defmodule DttRecharger.Operations.UserOperation do

  @moduledoc """
  The Schema context.
  """

  import Ecto.Query, warn: false
  alias DttRecharger.Operations.AccountOperation
  alias DttRecharger.Repo

  alias DttRecharger.Schema.{User, OrganizationRole}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    from(u in User) |> Repo.all
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
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}, organization) do
    org_role_params = List.first(attrs["organization_roles"])
    case AccountOperation.get_user_by_email(attrs["email"]) do
      user -> OrganizationRole.changeset(%OrganizationRole{}, Map.put(org_role_params, :user_id, user.id))
              |> Repo.insert
              AccountOperation.deliver_user_invitations(user, organization)
      nil -> user = %User{}
                    |> User.registration_changeset(attrs)
                    |> Repo.insert()
             AccountOperation.deliver_user_invitations(user, organization, attrs["password"])
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
    User.registration_changeset(user, attrs)
  end
end
