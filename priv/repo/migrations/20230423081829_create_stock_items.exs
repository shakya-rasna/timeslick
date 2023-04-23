defmodule DttRecharger.Repo.Migrations.CreateStockItems do
  use Ecto.Migration

  def change do
    create table(:stock_items) do
      add :activation_pin, :string
      add :dealers_name, :string
      add :recharge_number, :string
      add :description, :text
      add :denomination, :integer
      add :expiry_date, :date
      add :product_name, :string
      add :active, :boolean, default: false, null: false
      add :stock_file_id, references(:stock_files, on_delete: :nothing)
      add :status_id, references(:statuses, on_delete: :nothing)

      timestamps()
    end

    create index(:stock_items, [:stock_file_id])
    create index(:stock_items, [:status_id])
  end
end
