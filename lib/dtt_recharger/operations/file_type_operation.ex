defmodule DttRecharger.Operations.FileTypeOperation do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false
  alias DttRecharger.Repo
  alias DttRecharger.Schema.{FileType}

    def get_file_type_by_type(type) do
      Repo.get_by(FileType, type: type)
    end
  end
