defmodule DttRecharger.Repo do
  use Ecto.Repo,
    otp_app: :dtt_recharger,
    adapter: Ecto.Adapters.Postgres
end
