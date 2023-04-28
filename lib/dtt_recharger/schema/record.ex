defmodule DttRecharger.Schema.Record do
  use Ecto.Schema
  import Ecto.Changeset
  import DttRecharger.Helpers.StringParser
  alias DttRecharger.Schema.{OrderFile, Organization, Product}
  alias DttRecharger.Operations.ProductOperation

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
    belongs_to :product, Product, foreign_key: :product_id
    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:mobile_number, :product_name, :quantity, :id_number, :contract_number,
                    :surname, :initials, :amount, :entity_name, :order_file_id, :organization_id, :product_id])
    # |> validate_mobile_number(attrs)
    |> assoc_constraint(:order_file)
    |> assoc_constraint(:organization)
    |> assoc_constraint(:product)
    |> set_product_association
    |> validate_required([:mobile_number, :quantity, :id_number, :contract_number,
                          :surname, :initials, :amount, :entity_name, :order_file_id])
  end

  defp validate_mobile_number(changeset, attrs) do
    if attrs[:mobile_number] != nil &&  Regex.match?(~r/^\d{10}$/, attrs[:mobile_number]) do
      changeset
    else
      add_error(changeset, :mobile_number, "Invalid mobile number")
    end
  end

  def set_product_association(changeset) do
    if !is_nil(changeset.changes.product_name) do
      product = ProductOperation.get_product_by_back_name!(downcase(String.trim(List.last(split_string_by_X(changeset.changes.product_name)))))
      put_change(changeset, :product_id, (if is_nil(product), do: nil, else: product.id))
    else
      changeset
    end
  end
end
