defmodule DttRecharger.Operations.PayoutOperation do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{Payout}

  @doc """
  Returns the list of payouts.

  ## Examples

      iex> list_payouts()
      [%Payout{}, ...]

  """
  def list_payouts do
    Repo.all(Payout)
  end

  @doc """
  Gets a single payout.

  Raises `Ecto.NoResultsError` if the Payout does not exist.

  ## Examples

      iex> get_payout!(123)
      %Payout{}

      iex> get_payout!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payout!(id), do: Repo.get!(Payout, id)

  @doc """
  Creates a payout.

  ## Examples

      iex> create_payout(%{field: value})
      {:ok, %Payout{}}

      iex> create_payout(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payout(attrs \\ %{}) do
    %Payout{}
    |> Payout.changeset(attrs)
    |> Repo.insert()
  end

  def bulk_csv_import_payouts(attrs) do
    payout_changesets = Enum.map(attrs, fn attr -> Payout.changeset(%Payout{}, attr) end)
    result = payout_changesets
             |> Enum.with_index()
             |> Enum.reduce(Ecto.Multi.new(), fn ({changeset, index}, multi) ->
                  Ecto.Multi.insert(multi, Integer.to_string(index), changeset)
                end)
             |> Repo.transaction
    case result do
      {:ok, payouts } -> {:ok, payouts}
      {:error, _, changeset, _ } -> {:error, changeset}
    end
  end

  @doc """
  Updates a payout.

  ## Examples

      iex> update_payout(payout, %{field: new_value})
      {:ok, %Payout{}}

      iex> update_payout(payout, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payout(%Payout{} = payout, attrs) do
    payout
    |> Payout.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a payout.

  ## Examples

      iex> delete_payout(payout)
      {:ok, %Payout{}}

      iex> delete_payout(payout)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payout(%Payout{} = payout) do
    Repo.delete(payout)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payout changes.

  ## Examples

      iex> change_payout(payout)
      %Ecto.Changeset{data: %Payout{}}

  """
  def change_payout(%Payout{} = payout, attrs \\ %{}) do
    Payout.changeset(payout, attrs)
  end
end
