defmodule Scrivener.Ecto.User do
  use Ecto.Schema

  schema "users" do
    field(:email, :string)
  end
end
