defmodule DttRecharger.Repo.Migrations.CreateDeliveries do
  use Ecto.Migration

  def change do
    create table(:deliveries) do
      add :status, :string
      add :delivery_date, :naive_datetime
      add :record_id, references(:records, on_delete: :nothing)
      add :mobile_number, :string
      add :organization_id, references(:organizations, on_delete: :nothing)

      timestamps()
    end

    create index(:deliveries, [:record_id, :organization_id])
  end
end
