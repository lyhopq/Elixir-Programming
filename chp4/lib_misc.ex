defmodule Libmisc do
  def for_range(max, max, f), do: [f.(max)]
  def for_range(i, max, f), do: [f.(i) | for_range(i+1, max, f)]

  def qsort([]), do: []
  def qsort([pivot | t]) do
    qsort(for x <- t, x < pivot, do: x)
    ++ [pivot] ++
    qsort(for x <- t, x >= pivot, do: x)
  end

  def pythag(n) do
    seq = 1..n
    for a <- seq, b <- seq, c <-seq,
    a+b+c <= n, a*a + b*b == c*c,
    do: {a,b,c}
  end

  def perms([]), do: [[]]
  def perms(l), do: for h <- l, t <- perms(l -- [h]), do: [h|t]

  def odds_and_evevs1(l) do
    odds = for x <- l, rem(x, 2) === 1, do: x
    evens = for x <- l, rem(x, 2) === 0, do: x
    {odds, evens}
  end

  def odds_and_evevs2(l), do: odds_and_evevs_acc(l, [], [])

  defp odds_and_evevs_acc([h | t], odds, evens) do
    case rem(h, 2) do
      1 -> odds_and_evevs_acc(t, [h | odds], evens)
      0 -> odds_and_evevs_acc(t, odds, [h | evens])
    end
  end
  defp odds_and_evevs_acc([], odds, evens), do: {Enum.reverse(odds),
                                                 Enum.reverse(evens)}
end
