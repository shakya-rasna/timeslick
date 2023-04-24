defmodule DttRecharger.Repo.Migrations.AlterOrderFileColumns do
  use Ecto.Migration

  def change do
    alter table(:order_files) do
      add :uploader_id, references(:users, on_delete: :nothing)
    end

    create index(:order_files, [:uploader_id])
  end
end
