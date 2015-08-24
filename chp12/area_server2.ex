defmodule AreaServer2 do
  def rpc(pid, request) do
    send pid, {self, request}
    receive do
      {pid, response} ->
        response
    end
  end

  def loop do
    receive do
      {from, {:rectangle, width, heigh}} ->
        send from, {self, width * heigh}
      {from, {:circle, radius}} ->
        send from, {self, :math.pi * radius * radius}
      {from, other} ->
        send from, {self, {:error, other}}
    end
    loop
  end
end
