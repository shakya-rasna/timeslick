defmodule Timeslick.Repo.Migrations.CreatePayouts do
  use Ecto.Migration

  def change do
    create table(:payouts) do
      add :mobile_number, :string
      add :product_name, :string
      add :quantity, :integer
      add :id_number, :string
      add :contract_number, :string
      add :surname, :string
      add :initials, :string
      add :amount, :string
      add :entity_name, :string

      timestamps()
    end
  end
end
