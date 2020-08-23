defmodule TestRepo.Migrations.CreateUsers do
  use Ecto.Migration

  @prefixes ["tenant_1", "tenant_2"]

  def change do
    for prefix <- @prefixes do
      create table(:users, prefix: prefix) do
        add :email, :string
      end
    end
  end
end
