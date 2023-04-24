defmodule DttRecharger.Repo.Migrations.CreateStockFiles do
  use Ecto.Migration

  def change do
    create table(:stock_files) do
      add :upload_file_id, references(:upload_files, on_delete: :nothing)
      add :uploader_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:stock_files, [:upload_file_id, :uploader_id])
  end
end
