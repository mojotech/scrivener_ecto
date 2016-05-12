defmodule Scrivener.Paginator.Ecto.QueryTest do
  use Scrivener.Ecto.TestCase

  alias Scrivener.Ecto.{Comment, KeyValue, Post}

  defp create_posts do
    unpublished_post = %Post{
      title: "Title unpublished",
      body: "Body unpublished",
      published: false
    } |> Scrivener.Ecto.Repo.insert!

    Enum.map(1..2, fn i ->
      %Comment{
        body: "Body #{i}",
        post_id: unpublished_post.id
      } |> Scrivener.Ecto.Repo.insert!
    end)

    Enum.map(1..6, fn i ->
      %Post{
        title: "Title #{i}",
        body: "Body #{i}",
        published: true
      } |> Scrivener.Ecto.Repo.insert!
    end)
  end

  defp create_key_values do
    Enum.map(1..10, fn i ->
      %KeyValue{
        key: "key_#{i}",
        value: (rem(i, 2) |> to_string)
      } |> Scrivener.Ecto.Repo.insert!
    end)
  end

  describe "paginate" do
    it "paginates an unconstrained query" do
      create_posts

      page = Post |> Scrivener.Ecto.Repo.paginate

      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 7
      assert page.total_pages == 2
    end

    it "uses defaults from the repo" do
      posts = create_posts

      page =
        Post
        |> Post.published
        |> Scrivener.Ecto.Repo.paginate

      assert page.page_size == 5
      assert page.page_number == 1
      assert page.entries == Enum.take(posts, 5)
      assert page.total_entries == 6
      assert page.total_pages == 2
    end

    it "removes invalid clauses before counting total pages" do
      posts = create_posts

      page =
        Post
        |> Post.published
        |> order_by([p], desc: p.inserted_at)
        |> Scrivener.Ecto.Repo.paginate

      assert page.page_size == 5
      assert page.page_number == 1
      assert page.entries == Enum.take(posts, 5)
      assert page.total_pages == 2
    end

    it "can be provided the current page and page size as a params map" do
      posts = create_posts

      page =
        Post
        |> Post.published
        |> Scrivener.Ecto.Repo.paginate(%{"page" => "2", "page_size" => "3"})

      assert page.page_size == 3
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 3)
      assert page.total_pages == 2
    end

    it "can be provided the current page and page size as options" do
      posts = create_posts

      page =
        Post
        |> Post.published
        |> Scrivener.Ecto.Repo.paginate(page: 2, page_size: 3)

      assert page.page_size == 3
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 3)
      assert page.total_pages == 2
    end

    it "will respect the max_page_size configuration" do
      page =
        Post
        |> Post.published
        |> Scrivener.Ecto.Repo.paginate(%{"page" => "1", "page_size" => "20"})

      assert page.page_size == 10
    end

    it "can be used on a table with any primary key" do
      create_key_values

      page =
        KeyValue
        |> KeyValue.zero
        |> Scrivener.Ecto.Repo.paginate(page_size: 2)

      assert page.total_entries == 5
      assert page.total_pages == 3
    end

    it "can be used with a group by clause" do
      create_posts

      page =
        Post
        |> join(:left, [p], c in assoc(p, :comments))
        |> group_by([p], p.id)
        |> Scrivener.Ecto.Repo.paginate

      assert page.total_entries == 7
    end

    it "can be provided a Scrivener.Config directly" do
      posts = create_posts

      config = %Scrivener.Config{
        module: Scrivener.Ecto.Repo,
        page_number: 2,
        page_size: 4
      }

      page =
        Post
        |> Post.published
        |> Scrivener.paginate(config)

      assert page.page_size == 4
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 4)
      assert page.total_pages == 2
    end

    it "can be provided a keyword directly" do
      posts = create_posts

      page =
        Post
        |> Post.published
        |> Scrivener.paginate(module: Scrivener.Ecto.Repo, page: 2, page_size: 4)

      assert page.page_size == 4
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 4)
      assert page.total_pages == 2
    end

    it "can be provided a map directly" do
      posts = create_posts

      page =
        Post
        |> Post.published
        |> Scrivener.paginate(%{"module" => Scrivener.Ecto.Repo, "page" => 2, "page_size" => 4})

      assert page.page_size == 4
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 4)
      assert page.total_pages == 2
    end
  end
end
