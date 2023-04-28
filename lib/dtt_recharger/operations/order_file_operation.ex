defmodule DttRecharger.Operations.OrderFileOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{OrderFile, Record}
  alias DttRecharger.Operations.DeliveryOperation
  import DttRecharger.Services.DeliveryHandler

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
  Returns the list of organization_order_files.

  ## Examples

      iex> list_organization_order_files()
      [%OrderFile{}, ...]

  """
  def list_organization_order_files(organization_id) do
    from(sf in OrderFile, where: sf.organization_id == ^organization_id, preload: [:upload_file, :uploader, :authorizer]) |> Repo.all
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

  def authorize_payouts(order_file, current_user) do
    records = from(r in Record, where: r.order_file_id == ^order_file.id, preload: [:organization, :product]) |> Repo.all
    result = []
    delivery_attrs = Enum.map(records, fn record ->
      delivery_params = List.flatten(delivery_params(record))
      params = case record.product_id do
        nil ->
          Enum.map(delivery_params, fn delivery_param ->
            Map.merge(delivery_param, %{status: "failed", failure: %{status: "failed", error_message: "Package not found"}})
          end)
        _id ->
          Enum.map(delivery_params, fn delivery_param ->
            Map.merge(delivery_param, %{status: "scheduled", schedule: %{delivery_date: delivery_param[:delivery_date], status: "scheduled"}})
          end)
      end
      result = [params | result]
    end)
    case DeliveryOperation.create_multi_deliveries(List.flatten(delivery_attrs)) do
      {:ok, _deliveries} ->
        order_file
        |> OrderFile.authorize_changeset(%{authorize_status: "authorized",
                                           authorized_at: NaiveDateTime.utc_now(),
                                           authorizer_id: current_user.id})
        |> Repo.update
      {:error, changeset} -> {:error, changeset}
    end
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
