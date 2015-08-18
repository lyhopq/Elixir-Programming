defmodule MathFunctions do
  def even?(x), do: rem(x, 2) == 0
  def odd?(x), do: !even?(x)

  def filter(coll, f), do: for x <- coll, f.(x), do: x

  def split_with_acc(coll), do: split_with_acc(coll, [], [])
  defp split_with_acc([h | t], even, odd) do
    if even?(h) do
      split_with_acc(t, [h | even], odd)
    else
      split_with_acc(t, even, [h | odd])
    end
  end
  defp split_with_acc([], even, odd), do: {Enum.reverse(even),
                                           Enum.reverse(odd)}

  def split_with_filter(coll), do: {filter(coll, &even?/1),
                                    filter(coll, &odd?/1)}

end
