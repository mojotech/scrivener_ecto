defmodule Scrivener.Ecto.Mixfile do
  use Mix.Project

  def project do
    [
      app: :scrivener_ecto,
      version: "1.2.3",
      elixir: "~> 1.3",
      elixirc_paths: elixirc_paths(Mix.env),
      package: package(),
      description: "Paginate your Ecto queries with Scrivener",
      deps: deps(),
      aliases: aliases(),
      docs: [
        main: "readme",
        extras: [
          "README.md"
        ]
      ]
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
      applications: applications(Mix.env)
    ]
  end

  defp applications(:test), do: [:scrivener, :postgrex, :ecto, :logger]
  defp applications(_), do: [:scrivener, :logger]

  defp deps do
    [
      {:scrivener, "~> 2.3"},
      {:ecto, "~> 2.0"},
      {:dialyxir, "~> 0.5.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.16.0", only: :dev},
      {:postgrex, "~> 0.11.0 or ~> 0.12.0 or ~> 0.13.0", optional: true}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: ["Drew Olson"],
      licenses: ["MIT"],
      links: %{"github" => "https://github.com/drewolson/scrivener_ecto"},
      files: [
        "lib/scrivener",
        "mix.exs",
        "README.md"
      ]
    ]
  end
end
