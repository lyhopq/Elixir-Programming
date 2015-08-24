defmodule Clock do
  def start(time, fun) do
    Process.register spawn(fn -> tick(time, fun) end), :clock
  end

  def stop, do: send :clock, :stop

  def tick(time, fun) do
    receive do
      :stop ->
        :void
    after time ->
      fun.()
      tick(time, fun)
    end
  end
end
