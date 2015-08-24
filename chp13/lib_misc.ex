defmodule Libmisc do
  def on_eixt(pid, fun) do
    spawn(fn ->
      ref = Process.monitor(pid)
      receive do
        {:DOWN, ^ref, :process, ^pid, why} ->
          fun.(why)
      end
    end)
  end

  def keep_alive(name, fun) do
    Process.register(pid = spawn(fun), name)
    on_eixt(pid, fn(_why) -> keep_alive(name, fun) end)
  end
end
