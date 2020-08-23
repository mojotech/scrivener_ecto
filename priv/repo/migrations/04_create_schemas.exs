defmodule TestRepo.Migrations.CreateSchemas do
  use Ecto.Migration

  @prefixes ["tenant_1", "tenant_2"]

  def up do
    for prefix <- @prefixes do
      execute "CREATE SCHEMA #{prefix}"
    end
  end

  def down do
    for prefix <- @prefixes do
      execute "DROP SCHEMA #{prefix}"
    end
  end
end
