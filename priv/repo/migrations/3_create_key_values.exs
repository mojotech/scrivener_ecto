defmodule TestRepo.Migrations.CreateKeyValues do
  use Ecto.Migration

  def change do
    for prefix <- [nil] ++ Application.fetch_env!(:scrivener_ecto, :prefixes) do
      create table(:key_values, primary_key: false, prefix: prefix) do
        add :key, :string, primary_key: true
        add :value, :string
      end
    end
  end
end
