defmodule Fac1 do
  def main(n) do
    IO.puts "factirial #{n} = #{fac(n)}"
    :init.stop
  end

  def fac(0), do: 1
  def fac(n), do: n * fac(n-1)
end
