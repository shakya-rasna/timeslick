defmodule DttRecharger.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string

      timestamps()
    end

    create table(:organization_roles) do
      add :user_id, references(:users, on_delete: :nothing)
      add :organization_id, references(:organizations, on_delete: :nothing)
      add :role_id, references(:roles, on_delete: :nothing)
      add :sign_in_count, :integer, default: 0

      timestamps()
    end
    create unique_index(:organization_roles, [:user_id, :organization_id])
    create unique_index(:organization_roles, [:user_id, :organization_id, :role_id])
  end
end
