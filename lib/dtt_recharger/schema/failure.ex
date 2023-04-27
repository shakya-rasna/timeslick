defmodule DttRecharger.Schema.Failure do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.Delivery

  schema "failures" do
    field :error_message, :string
    field :status, :string
    belongs_to :delivery, Delivery, foreign_key: :delivery_id

    timestamps()
  end

  @doc false
  def changeset(failure, attrs) do
    failure
    |> cast(attrs, [:status, :error_message])
    |> assoc_constraint(:failure)
    |> validate_required([:status, :error_message])
  end
end
