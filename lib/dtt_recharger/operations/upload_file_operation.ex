defmodule DttRecharger.Operations.UploadFileOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  import DttRecharger.Helpers.StringParser

  alias DttRecharger.Repo
  alias DttRecharger.Schema.UploadFile

  def convert_params(data) do
    datas = data
    |> Enum.map(fn order_record_datas ->
      order_record_datas
      |> Enum.map(fn order_record_data -> order_record_data end)
      |> Enum.map(fn {key, value} -> {snakecase(key), value} end)
      |> Enum.into(%{})
      |> convert()
    end)
    {:ok, datas}
  end

  def convert(data) do
    for {key, val} <- data, into: %{}, do: {String.to_atom(key), val}
  end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking order_record changes.

    ## Examples

        iex> change_uploadfile(upload_file)
        %Ecto.Changeset{data: %UploadFile{}}
    """
    def change_uploadfile(%UploadFile{} = upload_file, attrs \\ %{}) do
      UploadFile.changeset(upload_file, attrs)
    end
  end
