defmodule DttRecharger.Schema.Record do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.OrderFile

  schema "records" do
    field :amount, :string
    field :contract_number, :string
    field :entity_name, :string
    field :id_number, :string
    field :initials, :string
    field :mobile_number, :string
    field :product_name, :string
    field :quantity, :integer
    field :surname, :string

    belongs_to :order_file, OrderFile, foreign_key: :order_file_id

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:mobile_number, :product_name, :quantity, :id_number, :contract_number, :surname, :initials, :amount, :entity_name])
    |> validate_required([:mobile_number, :product_name, :quantity, :id_number, :contract_number, :surname, :initials, :amount, :entity_name])
  end
end
