defmodule DateTime do
  def my_time_func(f) do
    start = :erlang.now
    result = f.()
    {time_difference(:erlang.now, start), result}
  end

  defp time_difference({mega_secs1, secs1, micro_secs1},
                       {mega_secs2, secs2, micro_secs2}) do
    (mega_secs1 - mega_secs2) * 1_000_000 + (secs1 - secs2) + (micro_secs1 - micro_secs2) * 0.000001
  end

  def my_date_string do
    {year, month, day} = :erlang.date
    {hour, minute, second} = :erlang.time
    IO.puts "#{year}-#{month}-#{day} #{hour}:#{minute}:#{second}"
  end
end
