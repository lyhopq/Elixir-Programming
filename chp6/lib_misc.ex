defmodule Libmisc do
  def sqrt(x) when x < 0 do
    :erlang.error({:squareRootNegativeArgument, x})
  end
  def sqrt(x), do: :math.sqrt(x)
end
