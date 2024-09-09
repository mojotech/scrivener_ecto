import Config

config :scrivener_ecto, ecto_repos: [Scrivener.Ecto.Repo]

config :scrivener_ecto, Scrivener.Ecto.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "scrivener_test",
  username: System.get_env("SCRIVENER_ECTO_DB_USER") || "postgres"

config :logger, :console, level: :error
