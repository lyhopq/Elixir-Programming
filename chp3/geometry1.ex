defmodule Geometry1 do
  def area({:rectangle, width, height}), do: width * height
  def area({:square, side}), do: side * side

  def test do
    12 = area({:rectangle, 3, 4})
    144 = area({:square, 12})
    :tests_worked
  end
end
