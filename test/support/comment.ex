defmodule Scrivener.Ecto.Comment do
  use Ecto.Schema

  schema "comments" do
    field :body, :string

    belongs_to :post, Scrivener.Ecto.Post

    timestamps()
  end
end
