defmodule DttRecharger.Repo.Migrations.AlterOrderStockColumns do
  use Ecto.Migration

  def change do
    alter table(:order_files) do
      add :organization_id, references(:organizations, on_delete: :nothing)
    end

    alter table(:records) do
      add :organization_id, references(:organizations, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)
    end

    create index(:order_files, [:organization_id])
    create index(:records, [:organization_id, :product_id])
  end
end
