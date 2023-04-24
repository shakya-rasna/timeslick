defmodule DttRecharger.Operations.StockItemOperation do
  @moduledoc """
  The Schema context.
  """

  import Ecto.Query, warn: false
  alias DttRecharger.Repo

  alias DttRecharger.Schema.StockItem

  @doc """
  Returns the list of stock_items.

  ## Examples

      iex> list_stock_items()
      [%StockItem{}, ...]

  """
  def list_stock_items do
    Repo.all(StockItem)
  end

  @doc """
  Gets a single stock_item.

  Raises `Ecto.NoResultsError` if the Stock item does not exist.

  ## Examples

      iex> get_stock_item!(123)
      %StockItem{}

      iex> get_stock_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stock_item!(id), do: Repo.get!(StockItem, id)

  @doc """
  Creates a stock_item.

  ## Examples

      iex> create_stock_item(%{field: value})
      {:ok, %StockItem{}}

      iex> create_stock_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stock_item(attrs \\ %{}) do
    %StockItem{}
    |> StockItem.changeset(attrs)
    |> Repo.insert()
  end

  def bulk_csv_import_stocks(attrs) do
    stock_changesets = Enum.map(attrs, fn attr -> StockItem.import_changeset(%StockItem{}, attr) end)
    result = stock_changesets
             |> Enum.with_index()
             |> Enum.reduce(Ecto.Multi.new(), fn ({changeset, index}, multi) ->
                  Ecto.Multi.insert(multi, Integer.to_string(index), changeset)
                end)
             |> Repo.transaction
    case result do
      {:ok, stocks } -> {:ok, stocks}
      {:error, _, changeset, _ } -> {:error, changeset}
    end
  end

  @doc """
  Updates a stock_item.

  ## Examples

      iex> update_stock_item(stock_item, %{field: new_value})
      {:ok, %StockItem{}}

      iex> update_stock_item(stock_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stock_item(%StockItem{} = stock_item, attrs) do
    stock_item
    |> StockItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stock_item.

  ## Examples

      iex> delete_stock_item(stock_item)
      {:ok, %StockItem{}}

      iex> delete_stock_item(stock_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock_item(%StockItem{} = stock_item) do
    Repo.delete(stock_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stock_item changes.

  ## Examples

      iex> change_stock_item(stock_item)
      %Ecto.Changeset{data: %StockItem{}}

  """
  def change_stock_item(%StockItem{} = stock_item, attrs \\ %{}) do
    StockItem.changeset(stock_item, attrs)
  end
end
