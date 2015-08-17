defmodule Geometry do
  def area({:rectangle, width, height}), do: width * height
  def area({:square, side}), do: side * side
  def area({:circle, radius}), do: :math.pi * radius * radius
  def area({:'right-triangle', a, h}), do: 0.5 * a * h

  def perimeter({:rectangle, width, height}), do: 2 * (width + height)
  def perimeter({:square, side}), do: 4 * side
  def perimeter({:circle, radius}), do: 4 * :math.pi * radius
  def perimeter({:'right-triangle', a, h}), do: a + h + :math.sqrt(a*a + h*h)
end
