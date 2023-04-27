defmodule DttRecharger.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :validity_in_days, :integer
      add :back_name, :string

      timestamps()
    end
  end
end
