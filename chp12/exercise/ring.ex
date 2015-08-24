defmodule Ring do
  def run(n, m, message) do
    pid = spawn(__MODULE__, :start_process, [n - 1])
    send pid, {:message, message, n*m}
  end

  def start_process(count) do
    pid = spawn(__MODULE__, :start_process, [count-1, self])
    loop(pid)
  end

  def start_process(0, last) do
    loop(last)
  end

  def start_process(count, last) do
    pid = spawn(__MODULE__, :start_process, [count-1, last])
    loop(pid)
  end


  def loop(next_pid) do
    receive do
      {:message, message, 0} ->
        IO.puts "#{inspect self} shutting down. next_pid: #{inspect next_pid}."
        :timer.sleep(3000)
        send next_pid, {:message, message, 0}
        :ok
      {:message, message, m} ->
        IO.puts "m: #{m}. self: #{inspect self}. next_pid: #{inspect next_pid}."
        :timer.sleep(3000)
        send next_pid, {:message, message, m-1}
        loop(next_pid)
    end
  end
end
