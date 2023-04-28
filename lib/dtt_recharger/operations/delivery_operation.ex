defmodule DttRecharger.Operations.DeliveryOperation do
  @moduledoc """
  The Deliveries context.
  """

  import Ecto.Query, warn: false
  alias DttRecharger.Repo

  alias DttRecharger.Schema.Delivery

  @doc """
  Returns the list of deliveries.

  ## Examples

      iex> list_deliveries()
      [%Delivery{}, ...]

  """
  def list_deliveries do
    Repo.all(from d in Delivery, preload: [:product])
  end

  def list_organization_deliveries(organization_id) do
    from(d in Delivery, where: d.organization_id == ^organization_id, preload: [:product]) |> Repo.all
  end

  @doc """
  Gets a single delivery.

  Raises `Ecto.NoResultsError` if the Delivery does not exist.

  ## Examples

      iex> get_delivery!(123)
      %Delivery{}

      iex> get_delivery!(456)
      ** (Ecto.NoResultsError)

  """
  def get_delivery!(id), do: Repo.get!(Delivery, id)

  @doc """
  Creates a delivery.

  ## Examples

      iex> create_delivery(%{field: value})
      {:ok, %Delivery{}}

      iex> create_delivery(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_delivery(attrs \\ %{}) do
    %Delivery{}
    |> Delivery.changeset(attrs)
    |> Repo.insert()
  end

  def create_multi_deliveries(attrs) do
    delivery_changesets = Enum.map(attrs, fn attr -> Delivery.changeset(%Delivery{}, attr) end)
    result = delivery_changesets
            |> Enum.with_index()
            |> Enum.reduce(Ecto.Multi.new(), fn ({changeset, index}, multi) ->
                Ecto.Multi.insert(multi, Integer.to_string(index), changeset)
              end)
            |> Repo.transaction
    case result do
      {:ok, deliveries } -> {:ok, deliveries}
      {:error, _, changeset, _ } -> {:error, changeset}
    end
  end

  @doc """
  Updates a delivery.

  ## Examples

      iex> update_delivery(delivery, %{field: new_value})
      {:ok, %Delivery{}}

      iex> update_delivery(delivery, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_delivery(%Delivery{} = delivery, attrs) do
    delivery
    |> Delivery.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a delivery.

  ## Examples

      iex> delete_delivery(delivery)
      {:ok, %Delivery{}}

      iex> delete_delivery(delivery)
      {:error, %Ecto.Changeset{}}

  """
  def delete_delivery(%Delivery{} = delivery) do
    Repo.delete(delivery)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking delivery changes.

  ## Examples

      iex> change_delivery(delivery)
      %Ecto.Changeset{data: %Delivery{}}

  """
  def change_delivery(%Delivery{} = delivery, attrs \\ %{}) do
    Delivery.changeset(delivery, attrs)
  end
end
