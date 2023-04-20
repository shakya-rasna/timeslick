defmodule DTTRecharger.Repo do
  use Ecto.Repo,
    otp_app: :dttrecharger,
    adapter: Ecto.Adapters.Postgres
end
