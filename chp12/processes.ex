defmodule Processes do
  @doc """
  创建n个进程然后销毁它们
  看看需要花费多少时间
  """
  def max(n) do
    max = :erlang.system_info(:process_limit)
    IO.puts "Maximum allowed processes: #{max}"
    :erlang.statistics(:runtime)
    :erlang.statistics(:wall_clock)
    l = for _ <- 1..n, do: spawn(&wait/0)
    {_, time1} = :erlang.statistics(:runtime)
    {_, time2} = :erlang.statistics(:wall_clock)
    Enum.each(l, fn pid -> send pid, :die end)
    u1 = time1 * 1000 / n
    u2 = time2 * 1000 / n
    IO.puts "Process spawn time=#{u1} (#{u2}) microseconds"
  end

  def wait do
    receive do
      :die -> :void
    end
  end
end
