defmodule Scrivener.Ecto.Mixfile do
  use Mix.Project

  def project do
    [
      app: :scrivener_ecto,
      version: "2.8.0-dev",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: "Paginate your Ecto queries with Scrivener",
      package: package(),
      deps: deps(),
      docs: docs(),
      aliases: aliases()
    ]
  end

  defp aliases do
    [
      "db.reset": [
        "ecto.drop",
        "ecto.create",
        "ecto.migrate"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:scrivener, "~> 2.4"},
      {:ecto, "~> 3.3"},
      {:ecto_sql, "~> 3.3", only: :test},
      {:dialyxir, "~> 1.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:postgrex, "~> 0.15.0", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: ["Drew Olson"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/scrivener_ecto/changelog.html",
        "GitHub" => "https://github.com/drewolson/scrivener_ecto"

      },
      files: [
        "lib/scrivener",
        "mix.exs",
        "CHANGELOG.md",
        "README.md",
        "LICENSE"
      ]
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", "README.md"],
      main: "readme",
      api_reference: false,
      extra_section: []
    ]
  end
end
