defmodule DttRecharger.Release.Seeder do
  @moduledoc """
  Release tasks for seeds.
  """

  require Logger

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :dtt_recharger
  ]
  def migrate do
    start_services()
    run_migrations()
    run_seeds()
    stop_services()
  end

  def seed do
    run_seeds()
  end

  @repos Application.compile_env(:dtt_recharger, :ecto_repos, [])

  defp start_services do
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # pool_size can be 1 for ecto < 3.0
    Enum.each(@repos, & &1.start_link(pool_size: 2))
  end

  defp stop_services do
    IO.puts("Success!")
    :init.stop()
  end

  defp run_migrations do
    for repo <- @repos do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  defp run_seeds do
    Enum.each(@repos, &run_seeds_for(&1))
  end

  defp run_seeds_for(repo) do
    # Run the seed script if it exists
    seed_script = priv_path_for(repo, "seeds.exs")
    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
      IO.puts("Data seeding has been completed")
    end
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config(), :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"

    Path.join([priv_dir, repo_underscore, filename])
  end
end
