defmodule DttRecharger.Repo.Migrations.AlterOrderFilecolumns do
  use Ecto.Migration

  def change do
    alter table(:order_files) do
      remove :file, :string
      add :total_records, :integer
      add :processed_records, :integer
      add :upload_file_id, references(:upload_files, on_delete: :nothing)
    end

    create index(:order_files, [:upload_file_id])
  end
end
