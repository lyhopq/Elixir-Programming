defmodule UdpTest do
  def start_server do
    spawn(fn -> server(4000) end)
  end

  defp server(port) do
    {:ok, socket} = :gen_udp.open(port, [:binary])
    IO.puts "server opend socket: #{inspect socket}"
    loop(socket)
  end

  defp loop(socket) do
    receive do
      {:udp, ^socket, host, port, bin} = msg ->
        IO.puts "server received: #{inspect msg}"
        n = :erlang.binary_to_term(bin)
        :gen_udp.send(socket, host, port, :erlang.term_to_binary(fac(n)))
        loop(socket)
    end
  end

  defp fac(0), do: 1
  defp fac(n), do: n * fac(n-1)

  def client(n) do
    {:ok, socket} = :gen_udp.open(0, [:binary])
    IO.puts "client opened socket=#{inspect socket}"
    :ok = :gen_udp.send(socket, 'localhost', 4000,
                        :erlang.term_to_binary(n))
    value = receive do
      {:udp, ^socket, _, _, bin} = msg ->
        IO.puts "client received:#{inspect msg}"
        :erlang.binary_to_term(bin)
    after 2000 ->
      0
    end
    :gen_udp.close(socket)
    value
  end
end
