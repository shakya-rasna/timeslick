defmodule DttRecharger.Repo.Migrations.CreateFileTypes do
  use Ecto.Migration

  def change do
    create table(:file_types) do
      add :type, :string

      timestamps()
    end
  end
end
