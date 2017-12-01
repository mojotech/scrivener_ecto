defimpl Scrivener.Paginater, for: Ecto.Query do
  import Ecto.Query

  alias Scrivener.{Config, Page}

  @moduledoc false

  @spec paginate(Ecto.Query.t, Scrivener.Config.t) :: Scrivener.Page.t
  def paginate(query, %Config{page_size: page_size, page_number: page_number, module: repo, caller: caller, options: options}) do
    opts = [prefix: Keyword.get_lazy(options, :prefix, fn -> nil end)]

    total_entries = Keyword.get_lazy(options, :total_entries, fn -> total_entries(query, repo, caller, opts) end)
    total_pages = total_pages(total_entries, page_size)
    page_number = min(total_pages, page_number)

    %Page{
      page_size: page_size,
      page_number: page_number,
      entries: entries(query, repo, page_number, page_size, caller, opts),
      total_entries: total_entries,
      total_pages: total_pages
    }
  end

  defp entries(query, repo, page_number, page_size, caller, opts \\ []) do
    offset = page_size * (page_number - 1)
    prefix = get_prefix(opts)

    query
    |> limit(^page_size)
    |> offset(^offset)
    |> Map.put(:prefix, prefix)
    |> repo.all(caller: caller)
  end

  defp total_entries(query, repo, caller, opts \\ []) do
    total_entries =
      query
      |> exclude(:preload)
      |> exclude(:order_by)
      |> prepare_select
      |> count(opts)
      |> repo.one(caller: caller)

    total_entries || 0
  end

  defp prepare_select(
    %{
      group_bys: [
        %Ecto.Query.QueryExpr{
          expr: [
            {{:., [], [{:&, [], [source_index]}, field]}, [], []} | _
          ]
        } | _
      ]
    } = query
  ) do
    query
    |> exclude(:select)
    |> select([x: source_index], struct(x, ^[field]))
  end
  defp prepare_select(query) do
    query
    |> exclude(:select)
  end

  defp count(query, opts \\ []) do
    prefix = get_prefix(opts)

    query
    |> Map.put(:prefix, prefix)
    |> subquery
    |> select(count("*"))
  end

  defp get_prefix(opts \\ []) do
    case Keyword.fetch(opts, :prefix) do
      {:ok, prefix} -> prefix
      :error -> nil
    end
  end

  defp total_pages(0, _), do: 1

  defp total_pages(total_entries, page_size) do
    (total_entries / page_size) |> Float.ceil |> round
  end
end
