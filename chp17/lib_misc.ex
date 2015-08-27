defmodule Libmisc do
  def string2value(str) do
    {:ok, tokens, _} = :erl_scan.string(to_char_list(str) ++ '.')
    {:ok, exprs} = :erl_parse.parse_exprs(tokens)
    bindings = :erl_eval.new_bindings
    {:value, value, _} = :erl_eval.exprs(exprs, bindings)
    value
  end
end
