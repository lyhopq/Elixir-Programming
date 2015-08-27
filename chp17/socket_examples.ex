defmodule SocketExamples do
  def nano_get_url, do: nano_get_url('www.baidu.com')

  def nano_get_url(host) do
    {:ok, socket} = :gen_tcp.connect(host, 80, [:binary, {:packet, 0}])
    :ok = :gen_tcp.send(socket, "GET / HTTP/1.0\r\n\r\n")
    receive_date(socket, [])
  end

  defp receive_date(socket, data) do
    receive do
      {:tcp, ^socket, bin} ->
        receive_date(socket, [bin | data])
      {:tcp_closed, ^socket} ->
        data |> Enum.reverse |> to_string
    end
  end

  def start_nano_server do
    {:ok, listen} = :gen_tcp.listen(2345, [:binary,
                                           {:packet, 4},
                                           {:reuseaddr, true},
                                          {:active, true}])
    {:ok, socket} = :gen_tcp.accept(listen)
    :gen_tcp.close(listen)
    loop(socket)
  end

  defp loop(socket) do
    receive do
      {:tcp, ^socket, bin} ->
        IO.puts "Server received binary = #{inspect(bin)}"
        str = :erlang.binary_to_term(bin)
        IO.puts "Server (unpacked) #{str}"
        reply = Libmisc.string2value(str)
        IO.puts "Server replying = #{inspect(reply)}"
        :gen_tcp.send(socket, :erlang.term_to_binary(reply))
        loop(socket)
      {:tcp_closed, ^socket} ->
        IO.puts "Server socket closed"
    end
  end

  def nano_client_eval(str) do
    {:ok, socket} = :gen_tcp.connect('localhost', 2345,
                                     [:binary, {:packet, 4}])
    :ok = :gen_tcp.send(socket, :erlang.term_to_binary(str))

    receive do
      {:tcp, ^socket, bin} ->
        IO.puts "Client received binary = #{inspect(bin)}"
        val = :erlang.binary_to_term(bin)
        IO.puts "Client result = #{inspect(val)}"
        :gen_tcp.close(socket)
    end
  end

  def start_seq_server do
    {:ok, listen} = :gen_tcp.listen(2345, [:binary,
                                           {:packet, 4},
                                           {:reuseaddr, true},
                                           {:active, true}])
    seq_loop(listen)
  end

  defp seq_loop(listen) do
    {:ok, socket} = :gen_tcp.accept(listen)
    loop(socket)
    seq_loop(listen)
  end

  def start_parallel_server do
    {:ok, listen} = :gen_tcp.listen(2345, [:binary,
                                           {:packet, 4},
                                           {:reuseaddr, true},
                                           {:active, true}])
    spawn(fn -> par_connect(listen) end)
  end

  defp par_connect(listen) do
    {:ok, socket} = :gen_tcp.accept(listen)
    spawn(fn -> par_connect(listen) end)
    loop(socket)
  end
end
