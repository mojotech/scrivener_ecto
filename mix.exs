defmodule Scrivener.Ecto.Mixfile do
  use Mix.Project

  def project do
    [
      app: :scrivener_ecto,
      version: "1.0.0-dev",
      elixir: "~> 1.2",
      elixirc_paths: elixirc_paths(Mix.env),
      package: package,
      description: "Paginate your Ecto queries with Scrivener",
      deps: deps,
      docs: [
        main: "README.md",
        readme: "README.md"
      ]
    ]
  end

  def application do
    [
      applications: applications(Mix.env)
    ]
  end

  defp applications(:test), do: [:postgrex, :ecto, :logger]
  defp applications(_), do: [:logger]

  defp deps do
    [
      {:scrivener, git: "https://github.com/drewolson/scrivener", branch: "v2"},
      {:ecto, "~> 2.0.0-rc"},
      {:dialyze, "~> 0.2.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.11.0", only: :dev},
      {:ex_spec, "~> 1.0", only: :test},
      {:postgrex, ">= 0.0.0", optional: true}
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
