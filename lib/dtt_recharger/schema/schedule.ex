defmodule DttRecharger.Schema.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.{StockItem, Delivery}

  schema "schedules" do
    field :delivered_date, :naive_datetime
    field :delivery_date, :naive_datetime
    field :queued_date, :naive_datetime
    field :status, Ecto.Enum, values: [:scheduled]
    belongs_to  :stock_item, StockItem, foreign_key: :stock_item_id
    belongs_to :delivery, Delivery, foreign_key: :delivery_id

    timestamps()
  end

  @doc false
  def changeset(schedule, attrs) do
    schedule
    |> cast(attrs, [:status, :delivery_date, :delivered_date, :queued_date, :stock_item_id, :delivery_id])
    |> assoc_constraint(:stock_item)
    |> assoc_constraint(:delivery)
    |> validate_required([:status, :delivery_date])
  end
end
