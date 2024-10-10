defimpl Scrivener.Paginater, for: Ecto.Query do
  import Ecto.Query

  alias Scrivener.{Config, Page}

  @moduledoc false

  @spec paginate(Ecto.Query.t(), Scrivener.Config.t()) :: Scrivener.Page.t()
  def paginate(query, %Config{
        page_size: page_size,
        page_number: page_number,
        module: repo,
        caller: caller,
        options: options
      }) do
    total_entries =
      options
      |> Keyword.put_new(:caller, caller)
      |> Keyword.get_lazy(:total_entries, fn ->
        aggregate(query, repo, options)
      end)

    total_pages = total_pages(total_entries, page_size)
    allow_overflow_page_number = Keyword.get(options, :allow_overflow_page_number, false)

    page_number =
      if allow_overflow_page_number, do: page_number, else: min(total_pages, page_number)

    %Page{
      page_size: page_size,
      page_number: page_number,
      entries: entries(query, repo, page_number, total_pages, page_size, options),
      total_entries: total_entries,
      total_pages: total_pages
    }
  end

  defp entries(_query, _repo, page_number, total_pages, _page_size, _options)
       when page_number > total_pages,
       do: []

  defp entries(query, repo, page_number, _total_pages, page_size, options) do
    offset = Keyword.get_lazy(options, :offset, fn -> page_size * (page_number - 1) end)

    query
    |> offset(^offset)
    |> limit(^page_size)
    |> repo.all(options)
  end

  defp aggregate(
         %{
           group_bys: [
             %{
               expr: [
                 {{:., [], [{:&, [], [source_index]}, field]}, [], []} | _
               ]
             }
             | _
           ]
         } = query,
         repo,
         options
       ) do
    query
    |> exclude(:preload)
    |> exclude(:order_by)
    |> exclude(:select)
    |> select([{x, source_index}], struct(x, ^[field]))
    |> subquery()
    |> select(count("*"))
    |> repo.one(options)
  end

  defp aggregate(query, repo, options) do
    repo.aggregate(query, :count, options)
  end

  defp total_pages(0, _), do: 1

  defp total_pages(total_entries, page_size) do
    (total_entries / page_size) |> Float.ceil() |> round
  end
end
