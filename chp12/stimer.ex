defmodule Stimer do
  def start(time, fun), do: spawn(fn -> timer(time, fun) end)

  def cancel(pid), do: send pid, :cancel

  def timer(time, fun) do
    receive do
      :cancel ->
        :void
    after time ->
      fun.()
    end
  end
end
