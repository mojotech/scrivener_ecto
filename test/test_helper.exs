defmodule Scrivener.Ecto.TestCase do
  use ExUnit.CaseTemplate

  using(opts) do
    quote do
      use ExUnit.Case, unquote(opts)
      import Ecto.Query
    end
  end

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(Scrivener.Ecto.Repo, :manual)

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Scrivener.Ecto.Repo)
  end
end

Scrivener.Ecto.Repo.start_link
ExUnit.start()
