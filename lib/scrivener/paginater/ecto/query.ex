defimpl Scrivener.Paginater, for: Ecto.Query do
  import Ecto.Query

  alias Scrivener.Config
  alias Scrivener.Page

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
    |> limit([_], ^page_size)
    |> offset([_], ^offset)
    |> repo.all
  end

  defp total_entries(query, repo) do
    stripped_query = query
    |> exclude(:order_by)
    |> exclude(:preload)
    |> exclude(:select)

    {query_sql, parameters} =  Ecto.Adapters.SQL.to_sql(:all, repo, stripped_query)
    {:ok, %{num_rows: 1, rows: [[count]]}} = Ecto.Adapters.SQL.query(repo, "SELECT count(*) FROM (#{query_sql}) AS temp", parameters)

    count
  end

  defp total_pages(total_entries, page_size) do
    ceiling(total_entries / page_size)
  end
end
