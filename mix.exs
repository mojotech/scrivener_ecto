defmodule Scrivener.Ecto.Mixfile do
  use Mix.Project

  @source_url "https://github.com/mojotech/scrivener_ecto"
  @version "3.1.1"

  def project do
    [
      app: :scrivener_ecto,
      version: @version,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      description: "Paginate your Ecto queries with Scrivener",
      source_url: @source_url,
      homepage_url: @source_url,
      deps: deps(),
      aliases: aliases(),
      docs: docs()
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
      {:ecto, "~> 3.12"},
      {:ecto_sql, "~> 3.12", only: :test},
      {:dialyxir, "~> 1.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.23", only: :dev},
      {:postgrex, "~> 0.19.1", only: :test}
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

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md": [title: "Overview"],
        "LICENSE": [title: "License"],
        "CHANGELOG.md": [title: "Changelog"]
      ],
      source_ref: "v#{@version}",
      formatters: ~w(html)
    ]
  end

  defp package do
    [
      maintainers: ["MojoTech"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mojotech/scrivener_ecto"},
      files: [
        "lib/scrivener",
        "mix.exs",
        "CHANGELOG.md",
        "LICENSE",
        "README.md"
      ]
    ]
  end
end
