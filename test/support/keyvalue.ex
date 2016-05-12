defmodule Scrivener.Ecto.KeyValue do
  use Ecto.Schema

  import Ecto.Query

  @primary_key {:key, :string, autogenerate: false}

  schema "key_values" do
    field :value, :string
  end

  def zero(query) do
    query |> where([p], p.value == "0")
  end
end
