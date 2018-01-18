defimpl Scrivener.Paginater, for: Atom do
  @moduledoc false

  @spec paginate(atom, Scrivener.Config.t()) :: Scrivener.Page.t()
  def paginate(atom, config) do
    atom
    |> Ecto.Queryable.to_query()
    |> Scrivener.Paginater.paginate(config)
  end
end
