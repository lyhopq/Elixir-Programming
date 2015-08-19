defmodule A do
  def start(tag) do
    spawn(fn -> loop(tag) end)
  end

  def loop(tag) do
    sleep()
    val = B.x
    IO.puts "Vsn1 (#{tag}) B.x = #{val}"
    loop(tag)
  end

  def sleep do
    receive do
      after 3000 -> true
    end
  end
end
