defmodule DttRecharger.Repo.Migrations.AlterRecordcolumns do
  use Ecto.Migration

  def change do
    alter table(:records) do
      add :order_file_id, references(:order_files, on_delete: :nothing)
    end

    create index(:records, [:order_file_id])
  end
end
