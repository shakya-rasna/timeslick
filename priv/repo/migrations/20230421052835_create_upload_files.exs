defmodule DttRecharger.Repo.Migrations.CreateUploadFiles do
  use Ecto.Migration

  def change do
    create table(:upload_files) do
      add :file, :string
      add :filename, :string
      add :path, :string
      add :content_type, :string
      add :file_type_id, references(:file_types, on_delete: :nothing)

      timestamps()
    end

    create index(:upload_files, [:file_type_id])
  end
end
