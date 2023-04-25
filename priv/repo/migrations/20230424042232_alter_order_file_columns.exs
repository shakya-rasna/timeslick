defmodule DttRecharger.Repo.Migrations.AlterOrderFileColumns do
  use Ecto.Migration

  def change do
    alter table(:order_files) do
      add :uploader_id, references(:users, on_delete: :nothing)
      add :authorizer_id, references(:users, on_delete: :nothing)
      add :authorized_at, :naive_datetime
    end

    create index(:order_files, [:uploader_id, :authorizer_id])
  end
end
