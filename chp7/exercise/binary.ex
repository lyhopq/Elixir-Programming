defmodule Binary do
  def reverse_byte_order(bin) when is_binary(bin), do: reverse_byte_order(bin, <<>>)
  defp reverse_byte_order(<<h, rest::binary>>, acc), do: reverse_byte_order(rest, <<h>> <> acc)
  defp reverse_byte_order(<<>>, acc), do: acc

  def reverse_bit_order(bin) do
    bits = (for <<x::1 <- bin>>, do: x)
           |> Enum.reverse
    for bit <- bits, into: <<>>, do: <<bit::1>>
  end
end
