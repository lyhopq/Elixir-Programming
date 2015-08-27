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
end
