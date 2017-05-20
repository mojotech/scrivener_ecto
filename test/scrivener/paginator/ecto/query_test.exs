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

  defp create_posts_with_comments do
      post_1 = %Post{title: "Title 1", body: "Body 1", published: true}
      |> Scrivener.Ecto.Repo.insert!
      post_2 = %Post{title: "Title 2", body: "Body 2", published: true}
      |> Scrivener.Ecto.Repo.insert!
      post_3 = %Post{title: "Title 3", body: "Body 3", published: true}
      |> Scrivener.Ecto.Repo.insert!
      post_4 = %Post{title: "Title 4", body: "Body 4", published: true}
      |> Scrivener.Ecto.Repo.insert!
      post_5 = %Post{title: "Title 5", body: "Body 5", published: true}
      |> Scrivener.Ecto.Repo.insert!
      post_6 = %Post{title: "Title 6", body: "Body 6", published: true}
      |> Scrivener.Ecto.Repo.insert!
      post_7 = %Post{title: "Title 7", body: "Body 7", published: true}
      |> Scrivener.Ecto.Repo.insert!

      %Comment{body: "Belongs to post_1", post_id: post_1.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_2", post_id: post_2.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_2", post_id: post_2.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_3", post_id: post_3.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_3", post_id: post_3.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_3", post_id: post_3.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_4", post_id: post_4.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_4", post_id: post_4.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_4", post_id: post_4.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_4", post_id: post_4.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_5", post_id: post_5.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_5", post_id: post_5.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_5", post_id: post_5.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_5", post_id: post_5.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_5", post_id: post_5.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_6", post_id: post_6.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_6", post_id: post_6.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_6", post_id: post_6.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_6", post_id: post_6.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_6", post_id: post_6.id}
      |> Scrivener.Ecto.Repo.insert!
      %Comment{body: "Belongs to post_6", post_id: post_6.id}
      |> Scrivener.Ecto.Repo.insert!

     post_1.id
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
    test "paginates with last_seen_id" do
      last_seen_id = create_posts_with_comments()

      query =
        from p in Post,
        left_join: c in assoc(p, :comments),
        order_by: [desc: count(c.id)],
        group_by: p.id,
        select: p

      # Test the sort order:
      # Page 1: Body 6, Body 5, Body 4, Body 3, Body 2
      # Page 2: Body 1, Body 7

      page = Scrivener.Ecto.Repo.paginate(query, %{"page" => 1})
      assert List.first(page.entries).body == "Body 6"
      page = Scrivener.Ecto.Repo.paginate(query, %{"page" => 2, "last_seen_id" => last_seen_id})
      assert List.first(page.entries).body == "Body 1"
    end

    test "paginates an unconstrained query" do
      create_posts()

      page = Post |> Scrivener.Ecto.Repo.paginate

      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 7
      assert page.total_pages == 2
    end

    test "page information is correct with no results" do
      page = Post |> Scrivener.Ecto.Repo.paginate

      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 0
      assert page.total_pages == 1
    end

    test "uses defaults from the repo" do
      posts = create_posts()

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

    test "it handles preloads" do
      create_posts()

      page =
        Post
        |> Post.published
        |> preload(:comments)
        |> Scrivener.Ecto.Repo.paginate

      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_pages == 2
    end

    test "it handles complex selects" do
      create_posts()

      page =
        Post
        |> join(:left, [p], c in assoc(p, :comments))
        |> group_by([p], p.id)
        |> select([p], sum(p.id))
        |> Scrivener.Ecto.Repo.paginate

      assert page.total_entries == 7
    end

    test "it handles complex order_by" do
      create_posts()

      page =
        Post
        |> select([p], fragment("? as aliased_title", p.title))
        |> order_by([p], fragment("aliased_title"))
        |> Scrivener.Ecto.Repo.paginate

      assert page.total_entries == 7
    end

    test "can be provided the current page and page size as a params map" do
      posts = create_posts()

      page =
        Post
        |> Post.published
        |> Scrivener.Ecto.Repo.paginate(%{"page" => "2", "page_size" => "3"})

      assert page.page_size == 3
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 3)
      assert page.total_pages == 2
    end

    test "can be provided the current page and page size as options" do
      posts = create_posts()

      page =
        Post
        |> Post.published
        |> Scrivener.Ecto.Repo.paginate(page: 2, page_size: 3)

      assert page.page_size == 3
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 3)
      assert page.total_pages == 2
    end

    test "can be provided the caller as options" do
      create_posts()
      parent = self()

      task = Task.async(fn ->
        Post
        |> Scrivener.Ecto.Repo.paginate(caller: parent)
      end)

      page = Task.await(task)

      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 7
      assert page.total_pages == 2
    end

    test "can be provided the caller as a map" do
      create_posts()
      parent = self()

      task = Task.async(fn ->
        Post
        |> Scrivener.Ecto.Repo.paginate(%{"caller" => parent})
      end)

      page = Task.await(task)

      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 7
      assert page.total_pages == 2
    end

    test "will respect the max_page_size configuration" do
      page =
        Post
        |> Post.published
        |> Scrivener.Ecto.Repo.paginate(%{"page" => "1", "page_size" => "20"})

      assert page.page_size == 10
    end

    test "can be used on a table with any primary key" do
      create_key_values()

      page =
        KeyValue
        |> KeyValue.zero
        |> Scrivener.Ecto.Repo.paginate(page_size: 2)

      assert page.total_entries == 5
      assert page.total_pages == 3
    end

    test "can be used with a group by clause" do
      create_posts()

      page =
        Post
        |> join(:left, [p], c in assoc(p, :comments))
        |> group_by([p], p.id)
        |> Scrivener.Ecto.Repo.paginate

      assert page.total_entries == 7
    end

    test "can be provided a Scrivener.Config directly" do
      posts = create_posts()

      config = %Scrivener.Config{
        module: Scrivener.Ecto.Repo,
        page_number: 2,
        page_size: 4,
        last_seen_id: 0
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

    test "can be provided a keyword directly" do
      posts = create_posts()

      page =
        Post
        |> Post.published
        |> Scrivener.paginate(module: Scrivener.Ecto.Repo, page: 2, page_size: 4)

      assert page.page_size == 4
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 4)
      assert page.total_pages == 2
    end

    test "can be provided a map directly" do
      posts = create_posts()

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
