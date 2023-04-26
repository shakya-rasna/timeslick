defmodule DttRecharger.Schema.Delivery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "deliveries" do
    field :delivery_date, :naive_datetime
    field :mobile_number, :string
    field :status, Ecto.Enum, values: [:completed, :failed, :scheduled]
    field :record_id, :id

    timestamps()
  end

  @doc false
  def changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [:status, :delivery_date])
    |> validate_required([:status, :delivery_date])
    |> validate_inclusion(:status, [:completed, :failed, :scheduled])
  end
end
