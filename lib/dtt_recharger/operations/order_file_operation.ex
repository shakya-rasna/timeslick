defmodule DttRecharger.Operations.OrderFileOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{OrderFile, Delivery}
  import DttRecharger.Services.DeliveryDateCalculator

  @doc """
  Returns the list of order_files.

  ## Examples

      iex> list_order_files()
      [%OrderFile{}, ...]

  """
  def list_order_files do
    from(sf in OrderFile, preload: [:upload_file, :uploader, :authorizer]) |> Repo.all
  end

  @doc """
  Gets a single order_file.

  Raises `Ecto.NoResultsError` if the Stock file does not exist.

  ## Examples

      iex> get_order_file!(123)
      %OrderFile{}

      iex> get_order_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_file!(id) do
    case Repo.get(OrderFile, id) do
      nil -> nil
      order_file -> Repo.preload(order_file, [:upload_file, :uploader, :authorizer])
    end
  end

  @doc """
  Creates a order_file.

  ## Examples

      iex> create_order_file(%{field: value})
      {:ok, %OrderFile{}}

      iex> create_order_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_file(attrs \\ %{}) do
    %OrderFile{}
    |> OrderFile.changeset(attrs)
    |> Repo.insert()
  end

  def authorize_payouts(order_file_id) do
    # records = from(r in Record, where: r.order_file_id == ^order_file_id) |> Repo.all()
    # Enum.map(records, fn record ->
    #   delivery = from(d in Delivery, where: d.mobile_number == ^record.mobile_number, order_by: [desc: q.delivery_date]) |> Repo.one
    #   case delivery do
    #     nil ->
    #   end
    # end)
  end

  @doc """
  Updates a order_file.

  ## Examples

      iex> update_order_file(order_file, %{field: new_value})
      {:ok, %OrderFile{}}

      iex> update_order_file(order_file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_file(%OrderFile{} = order_file, attrs) do
    order_file
    |> OrderFile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order_file.

  ## Examples

      iex> delete_order_file(order_file)
      {:ok, %OrderFile{}}

      iex> delete_order_file(order_file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_file(%OrderFile{} = order_file) do
    Repo.delete(order_file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_record changes.

  ## Examples

      iex> change_orderfile(order_file)
      %Ecto.Changeset{data: %OrderFile{}}
  """
  def change_orderfile(%OrderFile{} = order_file, attrs \\ %{}) do
    OrderFile.changeset(order_file, attrs)
  end
end
