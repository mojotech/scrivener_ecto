defmodule TestRepo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    for prefix <- [nil] ++ Application.fetch_env!(:scrivener_ecto, :prefixes) do
      create table(:posts, prefix: prefix) do
        add :title, :string
        add :body, :string
        add :published, :boolean

        timestamps()
      end
    end
  end
end
