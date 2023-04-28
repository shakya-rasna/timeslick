defmodule DttRecharger.Schema.Delivery do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.{Record, Organization, Product, Schedule, Failure}

  schema "deliveries" do
    field :delivery_date, :naive_datetime
    field :mobile_number, :string
    field :status, Ecto.Enum, values: [:completed, :failed, :scheduled]

    belongs_to :record, Record, foreign_key: :record_id
    belongs_to :organization, Organization, foreign_key: :organization_id
    belongs_to :product, Product, foreign_key: :product_id

    has_one :schedule, Schedule, on_delete: :delete_all
    has_one :failure, Failure, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [:status, :delivery_date, :mobile_number, :record_id, :organization_id, :product_id])
    |> assoc_constraint(:record)
    |> assoc_constraint(:organization)
    |> assoc_constraint(:product)
    |> cast_assoc(:schedule, with: &Schedule.changeset/2)
    |> cast_assoc(:failure, with: &Failure.changeset/2)
    |> validate_required([:status, :delivery_date, :mobile_number, :record_id, :product_id])
    |> validate_inclusion(:status, [:completed, :failed, :scheduled])
  end
end
