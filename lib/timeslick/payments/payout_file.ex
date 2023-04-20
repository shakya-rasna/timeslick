defmodule Timeslick.Payments.PayoutFile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payout_files" do
    field :file, :string

    timestamps()
  end

  @doc false
  def changeset(payout_file, attrs) do
    payout_file
    |> cast(attrs, [:file])
    |> validate_required([:file])
  end
end
