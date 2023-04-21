defmodule DttRecharger.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DttRechargerWeb.Telemetry,
      # Start the Ecto repository
      DttRecharger.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: DttRecharger.PubSub},
      # Start Finch
      {Finch, name: DttRecharger.Finch},
      # Start the Endpoint (http/https)
      DttRechargerWeb.Endpoint
      # Start a worker by calling: DttRecharger.Worker.start_link(arg)
      # {DttRecharger.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DttRecharger.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DttRechargerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
