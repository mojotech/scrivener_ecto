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

  defp entries(query, repo, page_number, page_size) do
    offset = page_size * (page_number - 1)

    query
    |> limit(^page_size)
    |> offset(^offset)
    |> repo.all
  end

  defp total_entries(query, repo) do
    primary_key =
      query.from
      |> elem(1)
      |> apply(:__schema__, [:primary_key])
      |> hd

    total_entries =
      query
      |> exclude(:order_by)
      |> exclude(:preload)
      |> exclude(:select)
      |> exclude(:group_by)
      |> select([m], count(field(m, ^primary_key), :distinct))
      |> repo.one

    total_entries || 0
  end

  defp total_pages(total_entries, page_size) do
    (total_entries / page_size) |> Float.ceil |> round
  end
end
