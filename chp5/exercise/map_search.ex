defmodule MapSearch do
  def map_search_pred(map, f) do
    (for {k, v} <- map, f.(k, v), do: {k ,v}) |> Enum.into(Map.new)
  end
end
