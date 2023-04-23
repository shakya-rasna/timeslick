defmodule DttRecharger.Operations.StockFileOperation do
  @moduledoc """
  The Schema context.
  """

  import Ecto.Query, warn: false
  alias DttRecharger.Repo

  alias DttRecharger.Schema.StockFile

  @doc """
  Returns the list of stock_files.

  ## Examples

      iex> list_stock_files()
      [%StockFile{}, ...]

  """
  def list_stock_files do
    Repo.all(StockFile)
  end

  @doc """
  Gets a single stock_file.

  Raises `Ecto.NoResultsError` if the Stock file does not exist.

  ## Examples

      iex> get_stock_file!(123)
      %StockFile{}

      iex> get_stock_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stock_file!(id), do: Repo.get!(StockFile, id)

  @doc """
  Creates a stock_file.

  ## Examples

      iex> create_stock_file(%{field: value})
      {:ok, %StockFile{}}

      iex> create_stock_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stock_file(attrs \\ %{}) do
    %StockFile{}
    |> StockFile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stock_file.

  ## Examples

      iex> update_stock_file(stock_file, %{field: new_value})
      {:ok, %StockFile{}}

      iex> update_stock_file(stock_file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stock_file(%StockFile{} = stock_file, attrs) do
    stock_file
    |> StockFile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stock_file.

  ## Examples

      iex> delete_stock_file(stock_file)
      {:ok, %StockFile{}}

      iex> delete_stock_file(stock_file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock_file(%StockFile{} = stock_file) do
    Repo.delete(stock_file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stock_file changes.

  ## Examples

      iex> change_stock_file(stock_file)
      %Ecto.Changeset{data: %StockFile{}}

  """
  def change_stock_file(%StockFile{} = stock_file, attrs \\ %{}) do
    StockFile.changeset(stock_file, attrs)
  end
end
