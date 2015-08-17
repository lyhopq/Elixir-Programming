defmodule Mylist do
  def sum([h | t]), do: h + sum(t)
  def sum([]), do: 0

  def map([], _), do: []
  def map([h | t], f), do: [f.(h) | map(t, f)]
end
