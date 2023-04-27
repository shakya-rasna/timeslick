defmodule DttRecharger.Repo.Migrations.CreateFailures do
  use Ecto.Migration

  def change do
    create table(:failures) do
      add :status, :string
      add :error_message, :string
      add :delivery_id, references(:deliveries, on_delete: :nothing)

      timestamps()
    end

    create index(:failures, [:delivery_id])
  end
end
