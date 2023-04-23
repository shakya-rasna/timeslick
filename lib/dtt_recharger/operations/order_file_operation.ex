defmodule DttRecharger.Operations.OrderFileOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  alias DttRecharger.Schema.{OrderFile}

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
