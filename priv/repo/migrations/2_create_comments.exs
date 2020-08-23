defmodule Scrivener.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    for prefix <- [nil] ++ Application.fetch_env!(:scrivener_ecto, :prefixes) do
      create table(:comments, prefix: prefix) do
        add :body, :string
        add :post_id, :integer

        timestamps()
      end
    end
  end
end
