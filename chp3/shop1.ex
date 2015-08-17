defmodule Shop1 do
  require Shop

  def total([{what, n} | t]), do: Shop.cost(what) * n + total(t)
  def total([]), do: 0
end
