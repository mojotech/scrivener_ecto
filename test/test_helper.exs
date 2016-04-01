defmodule Scrivener.Ecto.TestCase do
  use ExUnit.CaseTemplate

  using(opts) do
    quote do
      use ExSpec, unquote(opts)
      import Ecto.Query
    end
  end

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(ScrivenerEcto.Repo, :manual)

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ScrivenerEcto.Repo)
  end
end

ScrivenerEcto.Repo.start_link
ExUnit.start()
