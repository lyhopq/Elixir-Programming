defmodule Geometry do
  def area({:rectangle, width, height}), do: width * height
  def area({:square, side}), do: side * side
end
