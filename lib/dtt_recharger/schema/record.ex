defmodule DttRecharger.Schema.Record do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.{OrderFile, Organization}

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

    belongs_to :organization, Organization, foreign_key: :organization_id
    belongs_to :order_file, OrderFile, foreign_key: :order_file_id

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:mobile_number, :product_name, :quantity, :id_number, :contract_number,
                    :surname, :initials, :amount, :entity_name, :order_file_id, :organization_id])
    # |> validate_mobile_number(attrs)
    |> assoc_constraint(:order_file)
    |> assoc_constraint(:organization)
    |> validate_required([:mobile_number, :product_name, :quantity, :id_number, :contract_number,
                          :surname, :initials, :amount, :entity_name, :order_file_id, :organization_id])
  end

  defp validate_mobile_number(changeset, attrs) do
    if attrs[:mobile_number] != nil &&  Regex.match?(~r/^\d{10}$/, attrs[:mobile_number]) do
      changeset
    else
      add_error(changeset, :mobile_number, "Invalid mobile number")
    end
  end
end
