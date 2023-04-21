defmodule DttRecharger.Repo.Migrations.RenamePayoutTable do
  use Ecto.Migration

  def change do
    rename table(:payouts), to: table(:records)
    rename table(:payout_files), to: table(:order_files)
  end
end
