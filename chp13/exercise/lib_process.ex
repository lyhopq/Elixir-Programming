defmodule Libprocess do
  def my_spawn1(mod, func, args) do
    {pid, ref} = spawn_monitor(mod, func, args)
    start = :erlang.now
    receive do
      {:DOWN, ^ref, :process, ^pid, why} ->
        IO.puts "#{inspect pid} exit resion: #{why}.
        Survival: #{time_difference(:erlang.now, start)}s"
    end
  end
  
  def f(x), do: :timer.sleep(x)

  defp time_difference({mega_secs1, secs1, micro_secs1},
                       {mega_secs2, secs2, micro_secs2}) do
    (mega_secs1 - mega_secs2) * 1_000_000 + (secs1 - secs2) + (micro_secs1 - micro_secs2) * 0.000001
  end

  def my_spawn2(mod, func, args) do
    pid = spawn(mod, func, args)
    start = :erlang.now
    on_eixt(pid,
      fn why ->
        IO.puts "#{inspect pid} exit resion: #{why}.
        Survival: #{time_difference(:erlang.now, start)}s"
    end)
  end

  defp on_eixt(pid, fun) do
    spawn(fn ->
      ref = Process.monitor(pid)
      receive do
        {:DOWN, ^ref, :process, ^pid, why} ->
          fun.(why)
      end
    end)
  end

  def my_spawn3(mod, func, args, time) do
    pid = spawn(mod, func, args)
    receive do
    after
      time ->
        Process.exit(pid, :timeout)
    end
  end

  def running_server do
    pid = spawn(&running/0)
    Process.register(pid, :running)
  end

  defp running do
    IO.puts "I'm running."
    receive do
    after
      5000 ->
        running
    end
  end

  def running_montior do
    pid = Process.whereis(:running)
    ref = Process.monitor(pid)
    receive do
      {:DOWN, ^ref, :process, ^pid, _why} ->
        running_server
    end
    running_montior
  end

  def montior_process1(funs) do
    funs
    |> Enum.map(&process/1)
  end

  defp process(fun) do
    {pid, ref} = spawn_monitor(fun)
    on_eixt(pid,
            fn
              :normal ->
                IO.puts "work process eixt normal."
              why ->
                IO.puts "restart work process."
              process(fun)
            end)
    pid
  end

  def montior_process2(funs) do
    spawn(fn ->
      pids = for fun <- funs, do: spawn_monitor(fun)
      IO.puts "#{inspect pids}"
      receive do
        {:DOWN, ref, :process, pid, why} ->
          IO.puts "#{inspect pid} #{why}"
          if Enum.member?(pids, {pid, ref}) and why != :normal do
            (pids -- [{pid, ref}])
            |> Enum.each(fn {pid, _ref} -> Process.exit(pid, :kill) end)
            montior_process2(funs)
          end
      end
    end
    )
  end
end
