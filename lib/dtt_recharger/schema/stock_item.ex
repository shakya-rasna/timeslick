defmodule DttRecharger.Schema.StockItem do
  use Ecto.Schema
  import Ecto.Changeset
  import DttRecharger.Helpers.{Converter, StringParser}

  alias DttRecharger.Schema.{Status, StockFile}

  schema "stock_items" do
    field :activation_pin, :string
    field :dealers_name, :string
    field :description, :string
    field :active, :boolean, default: false
    field :denomination, :integer
    field :expiry_date, :date
    field :product_name, :string
    field :recharge_number, :string

    belongs_to :status, Status, foreign_key: :status_id
    belongs_to :stock_file, StockFile, foreign_key: :stock_file_id

    timestamps()
  end

  @doc false
  def changeset(stock_item, attrs) do
    attrs = Map.merge(attrs, %{activation_pin: attrs[:voucher_pin], recharge_number: attrs[:serial_number],
                               denomination: convert!(attrs[:denomination]), active: convert!(downcase(attrs[:active]))})
    stock_item
    |> cast(attrs, [:activation_pin, :recharge_number, :denomination, :product_name, :active, :stock_file_id, :dealers_name, :description])
    |> assoc_constraint(:status)
    |> assoc_constraint(:stock_file)
    |> validate_required([:activation_pin, :recharge_number, :denomination, :active, :stock_file_id])
  end
end
