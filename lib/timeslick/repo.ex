defmodule Timeslick.Repo do
  use Ecto.Repo,
    otp_app: :timeslick,
    adapter: Ecto.Adapters.Postgres
end
