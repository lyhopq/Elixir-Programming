defmodule Packet do
  def term_to_packet(term) do
    bin = :erlang.term_to_binary(term)
    <<byte_size(bin)::size(32)>> <> bin
  end

  def packet_to_term(<<n::size(32), bin::binary>>) when byte_size(bin) == n do
    :erlang.binary_to_term(bin)
  end
end

ExUnit.start

defmodule PacketTest do
  use ExUnit.Case
  import Packet

  test "packet test" do
    assert term_to_packet(0) == <<0, 0, 0, 3, 131, 97, 0>>
  end

  test "unpacket test" do
    assert packet_to_term(<<0, 0, 0, 3, 131, 97, 0>>) == 0
  end

end
