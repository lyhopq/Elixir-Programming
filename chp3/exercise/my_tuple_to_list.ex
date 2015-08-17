defmodule Mytupletolist do
  def my_tuple_to_list(tuple) do
    for index <- 0..tuple_size(tuple)-1, do: elem(tuple, index)
  end
end
