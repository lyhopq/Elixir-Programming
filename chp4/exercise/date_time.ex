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

  # defp time_difference(t1, t2) do
  #   {days, {hours, minutes, seconds}} = :calendar.time_difference(
  #     :calendar.now_to_local_time(t2),
  #     :calendar.now_to_local_time(t2)
  #   )
  #   (days * 24 * 60 * 60) + (hours * 60 * 60) + (minutes * 60) + seconds
  # end

  def my_date_string do
    {year, month, day} = :erlang.date
    {hour, minute, second} = :erlang.time
    IO.puts "#{year}-#{month}-#{day} #{hour}:#{minute}:#{second}"
  end
end
