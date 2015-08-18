defmodule TryTest do
  def generate_exception(1), do: :a
  def generate_exception(2), do: throw(:a)
  def generate_exception(3), do: :erlang.exit(:a)
  def generate_exception(4), do: {'EXIT', :a}
  def generate_exception(5), do: :erlang.error(:a)

  def demo1 do
    for x <- 1..5, do: catcher(x)
  end

  defp catcher(x) do
    try do
      {x, :normal, generate_exception(x)}
    catch
      :throw, v -> {x, :caught, :thrown, v}
      :exit, v  -> {x, :caught, :exited, v}
      :error, v -> {x, :caught, :error, v}
    end
  end

  def demo3 do
    try do
      generate_exception(5)
    catch
      :error, x ->
        {x, :erlang.get_stacktrace}
    end
  end
end
