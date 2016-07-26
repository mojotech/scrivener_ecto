defimpl Scrivener.Paginater, for: Ecto.Query do
  import Ecto.Query

  alias Scrivener.{Config, Page}

  @moduledoc false

  @spec paginate(Ecto.Query.t, Scrivener.Config.t) :: Scrivener.Page.t
  def paginate(query, %Config{page_size: page_size, page_number: page_number, module: repo}) do
    total_entries = total_entries(query, repo)

    %Page{
      page_size: page_size,
      page_number: page_number,
      entries: entries(query, repo, page_number, page_size),
      total_entries: total_entries,
      total_pages: total_pages(total_entries, page_size)
    }
  end

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t
      pos when pos > 0 ->
        t + 1
      _ -> t
    end
  end

  defp entries(query, repo, page_number, page_size) do
    offset = page_size * (page_number - 1)

    query
    |> limit(^page_size)
    |> offset(^offset)
    |> repo.all
  end

  defp total_entries(query, repo) do
    # select count(*) from (select a, b from t group by a, b) x
    # equivalent: select count(distinct(a, b)) from t
    
    primary_keys = query.from
      |> elem(1)
      |> apply(:__schema__, [:primary_key])
    
    base_query = query
      |> exclude(:order_by)
      |> exclude(:preload)
      |> exclude(:select)
      |> exclude(:group_by)
      |> group_by([x], ^primary_keys)
      |> select([x], map(x, ^primary_keys))
    
    from(subquery(base_query), select: fragment("count(*)"))
      |> repo.one!
  end

  defp total_pages(total_entries, page_size) do
    ceiling(total_entries / page_size)
  end
end
