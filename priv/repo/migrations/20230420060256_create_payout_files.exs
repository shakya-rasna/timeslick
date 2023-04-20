defmodule Timeslick.Repo.Migrations.CreatePayoutFiles do
  use Ecto.Migration

  def change do
    create table(:payout_files) do
      add :file, :string

      timestamps()
    end
  end
end
