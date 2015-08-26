defmodule Register do
  def start(name, fun) do
    case Process.whereis(name) do
      nil ->
        Process.register spawn(fn -> fun.() end), name
      _ ->
        false
    end
  end
end
