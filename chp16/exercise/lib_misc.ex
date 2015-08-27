defmodule Libmisc do
  def need_compile?(file) do
    if :filelib.is_file(file) and :filename.extension(file) == ".erl" do
      beam = :filename.rootname(file) <> ".beam"
      !(:filelib.is_file(beam) and !newer?(:filelib.last_modified(file), :filelib.last_modified(beam)))
    else
      false
    end
  end

  defp newer?({date1, time1}, {date2, time2}) do
    Enum.zip(
      Tuple.to_list(date1) ++ Tuple.to_list(time1),
      Tuple.to_list(date2) ++ Tuple.to_list(time2)
    )
    |> newer?
  end
  defp newer?([{t1, t2} | t]) do
    case t1 - t2 do
      v when v > 0 -> true
      v when v < 0 -> false
      _ -> newer?(t)
    end
  end
  defp newer?([]), do: false
end
