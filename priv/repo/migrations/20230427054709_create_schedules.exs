defmodule DttRecharger.Repo.Migrations.CreateSchedules do
  use Ecto.Migration

  def change do
    create table(:schedules) do
      add :status, :string
      add :delivery_date, :naive_datetime
      add :delivered_date, :naive_datetime
      add :queued_date, :naive_datetime
      add :delivery_id, references(:deliveries, on_delete: :nothing)
      add :stock_item_id, references(:stock_items, on_delete: :nothing)

      timestamps()
    end

    create index(:schedules, [:delivery_id])
    create index(:schedules, [:stock_item_id])
  end
end
