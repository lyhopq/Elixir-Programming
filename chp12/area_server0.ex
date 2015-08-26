defmodule AreaServer0 do
  def loop do
    receive do
      {:rectangle, width, heigh} ->
        IO.puts "Area of rectangle is #{width*heigh}"
      {:square, side} ->
        IO.puts "Area of square is #{:math.pi*side*side}"
    end
    loop
  end
end
