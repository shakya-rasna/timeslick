defmodule DttRecharger.Schema.OrderFile do
  use Ecto.Schema
  import Ecto.Changeset

  alias DttRecharger.Schema.{UploadFile, Record, User}

  schema "order_files" do
    field :total_records, :integer
    field :processed_records, :integer
    field :authorized_at, :naive_datetime

    belongs_to :upload_file, UploadFile, foreign_key: :upload_file_id
    has_many :records, Record, on_replace: :delete
    belongs_to :uploader, User, foreign_key: :uploader_id
    belongs_to :authorizer, User, foreign_key: :authorizer_id
    belongs_to :organization, User, foreign_key: :organization_id

    timestamps()
  end

  @doc false
  def changeset(order_file, attrs) do
    order_file
    |> cast(attrs, [:total_records, :processed_records, :upload_file_id, :uploader_id, :authorizer_id, :organization_id])
    |> assoc_constraint(:upload_file)
    |> assoc_constraint(:uploader)
    |> assoc_constraint(:authorizer)
    |> assoc_constraint(:organization)
    |> validate_required([:total_records, :upload_file_id, :uploader_id, :organization_id])
  end

  def authorize_changeset(order_file, attrs) do
    order_file
    |> cast(attrs, [:authorizer_id, :authorized_at])
    |> assoc_constraint(:authorizer)
    |> validate_required([:authorizer_id, :authorized_at])
  end
end
