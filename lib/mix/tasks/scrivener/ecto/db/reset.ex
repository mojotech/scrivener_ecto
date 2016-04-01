defmodule Mix.Tasks.Scrivener.Ecto.Db.Reset do
  use Mix.Task

  @moduledoc false

  def run(_args) do
    Logger.configure(level: :error)

    Mix.Task.run("ecto.drop", [])
    Mix.Task.run("ecto.create", [])
    Mix.Task.run("ecto.migrate", [])
  end
end
