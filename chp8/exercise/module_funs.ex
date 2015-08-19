defmodule ModuleFuns do
  def most_func_module(num \\ 1) do
    modele_funs
    |> Enum.map(fn {mod, funs} -> {mod, length(funs)} end)
    |> Enum.sort_by(&(&1 |> elem(1)) , &(>=/2))
    |> Enum.take(num)
  end

  def most_common_fun(num \\ 1) do
    count_funs
    |> Enum.sort_by(fn {_fun, count} -> count end, &(>=/2))
    |> Enum.take(num)
  end

  def no_ambiguity_funs do
    count_funs
    |> Enum.filter(fn {_fun, count} -> count == 1 end)
  end

  defp modele_funs do
    :code.all_loaded
    |> Enum.map fn {mod, _} ->
      {mod, apply(mod, :module_info, [])
       |> List.first |> elem(1)}
      end
  end

  defp count_funs do
    modele_funs
    |> Enum.reduce(HashDict.new,
      fn ({_mod, funs}, acc) ->
        Dict.merge(acc, Enum.into(funs, HashDict.new),
          fn (_k, v1, v2) -> v1 + v2 end)
      end
    )
  end
end
