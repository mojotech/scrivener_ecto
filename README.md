# Scrivener.Ecto

[![Build Status](https://travis-ci.org/drewolson/scrivener_ecto.svg?branch=master)](https://travis-ci.org/drewolson/scrivener_ecto)
[![Module Version](https://img.shields.io/hexpm/v/scrivener_ecto.svg)](https://hex.pm/packages/scrivener_ecto)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/scrivener_ecto/)
[![Total Download](https://img.shields.io/hexpm/dt/scrivener_ecto.svg)](https://hex.pm/packages/scrivener_ecto)
[![License](https://img.shields.io/hexpm/l/scrivener_ecto.svg)](https://github.com/drewolson/scrivener_ecto/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/drewolson/scrivener_ecto.svg)](https://github.com/drewolson/scrivener_ecto/commits/master)

**Low Maintenance Warning**

This library is in low maintenance mode, which means the author is currently only responding to pull requests and breaking issues.

---

`Scrivener.Ecto` allows you to paginate your Ecto queries with Scrivener. It gives you useful information such as the total number of pages, the current page, and the current page's entries. It works nicely with Phoenix as well.

**Note:** `Scrivener.Ecto` only supports Ecto backends that allow subqueries (e.g. PostgreSQL).

## Usage

First, you'll want to `use` Scrivener in your application's `Ecto.Repo`. This will add a `paginate` function to your Repo. Defaults for `page_size` can be configured when you `use` Scrivener. If no `page_size` is provided, Scrivener will use `10` by default.

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
```

This `paginate` function expects to be called with, at a minimum, an Ecto query. It will then paginate the query and execute it, returning a `Scrivener.Page`.

```elixir
defmodule MyApp.Person do
  use Ecto.Schema

  schema "people" do
    field :name, :string
    field :age, :integer

    has_many :friends, MyApp.Person
  end
end
```

```elixir
def index(conn, params) do
  page =
    MyApp.Person
    |> where([p], p.age > 30)
    |> order_by(desc: :age)
    |> preload(:friends)
    |> MyApp.Repo.paginate(params)

  render conn, :index,
    people: page.entries,
    page_number: page.page_number,
    page_size: page.page_size,
    total_pages: page.total_pages,
    total_entries: page.total_entries
end
```

You may also want to call `paginate` with a params map along with your query. If provided with a params map, Scrivener will use the values in the keys `"page"` and `"page_size"` before using any configured defaults.

```elixir
page =
  MyApp.Person
  |> where([p], p.age > 30)
  |> order_by(desc: :age)
  |> preload(:friends)
  |> MyApp.Repo.paginate(page: 2, page_size: 5)
```

See the [test cases](https://github.com/drewolson/scrivener_ecto/blob/master/test/scrivener/paginator/ecto/query_test.exs) for additional options and usage.

## Installation

Add `:scrivener_ecto` to your `mix.exs` `deps`:

```elixir
defp deps do
  [
    {:scrivener_ecto, "~> 2.0"}
  ]
end
```

## Contributing

First, you'll need to build the test database:

```elixir
MIX_ENV=test mix db.reset
```

This task assumes you have postgres installed and that the `postgres` user can create / drop databases. If you'd prefer to use a different user, you can specify it with the environment variable `SCRIVENER_ECTO_DB_USER`.

With the database built, you can now run the tests:

```elixir
mix test
```

## Copyright and License

Copyright (c) 2016 Andrew Olson

This library is MIT licensed. See the
[LICENSE](https://github.com/drewolson/scrivener_ecto/blob/master/LICENSE) for details.
