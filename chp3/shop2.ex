defmodule Shop2 do
  require Shop
  import Enum, only: [map: 2, sum: 1]

  def total(coll), do: sum(map(coll, fn {what, n} -> Shop.cost(what) * n end))
end
