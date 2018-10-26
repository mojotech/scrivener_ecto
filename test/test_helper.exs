defmodule Scrivener.Ecto.TestCase do
  use ExUnit.CaseTemplate

  using opts do
    quote do
      use ExUnit.Case, unquote(opts)
      import Ecto.Query
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Scrivener.Ecto.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Scrivener.Ecto.Repo, {:shared, self()})
  end
end

Scrivener.Ecto.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(Scrivener.Ecto.Repo, :manual)

ExUnit.start()
