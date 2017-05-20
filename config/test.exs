use Mix.Config

config :scrivener_ecto, ecto_repos: [Scrivener.Ecto.Repo]

config :scrivener_ecto, Scrivener.Ecto.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "scrivener_test",
  username: System.get_env("PG_DB_USER"),
  password: System.get_env("PG_DB_PASSWORD")

config :logger, :console,
  level: :error
