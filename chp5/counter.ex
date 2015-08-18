defmodule Counter do
  def count_characters(str), do: count_characters(str, Map.new)
  defp count_characters([h | t], m) do
    count_characters(t, Dict.put(m, h, Dict.get(m, h, 0)+1))
  end
  defp count_characters([], m), do: m
end
