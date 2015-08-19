defmodule Attrs do
  @moduledoc """
  Elixir module's attribute.
  """

  @vsn 1234
  @autor {:joe, :armstrong}
  @purpose "example of attributes"

  def fac(1), do: 1
  def fac(n), do: n * fac(n-1)
end
