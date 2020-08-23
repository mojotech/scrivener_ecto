defmodule Scrivener.Paginator.Ecto.PrefixTest do
  use Scrivener.Ecto.TestCase

  alias Scrivener.Ecto.User

  defp create_users(number, prefix) do
    Enum.map(1..number, fn i ->
      %User{email: "user_#{i}@#{prefix}.com"}
      |> Scrivener.Ecto.Repo.insert!(prefix: prefix)
    end)
  end

  @schema_tenant_1 "tenant_1"
  @schema_tenant_2 "tenant_2"

  describe "prefix" do
    test "can specify prefix" do
      create_users(6, @schema_tenant_1)
      create_users(2, @schema_tenant_2)

      page_tenant_1 = Scrivener.Ecto.Repo.paginate(User, options: [prefix: @schema_tenant_1])

      assert page_tenant_1.page_size == 5
      assert page_tenant_1.page_number == 1
      assert page_tenant_1.total_entries == 6
      assert page_tenant_1.total_pages == 2

      page_tenant_2 = Scrivener.Ecto.Repo.paginate(User, options: [prefix: @schema_tenant_2])

      assert page_tenant_2.page_size == 5
      assert page_tenant_2.page_number == 1
      assert page_tenant_2.total_entries == 2
      assert page_tenant_2.total_pages == 1
    end
  end
end
