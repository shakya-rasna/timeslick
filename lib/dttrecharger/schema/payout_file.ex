defmodule DTTRecharger.Schema.PayoutFile do
  use Ecto.Schema
  import Ecto.Changeset
  use  Waffle.Ecto.Schema

  schema "payout_files" do
    field :file, DTTRecharger.FileCsv.Type

    timestamps()
  end

  @doc false
  def changeset(payout_file, attrs) do
    payout_file
    |> cast(attrs, [])
    |> cast_attachments(attrs, [:file])
    |> validate_required([:file])
  end
end
