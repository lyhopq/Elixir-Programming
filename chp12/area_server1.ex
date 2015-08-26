defmodule AreaServer1 do
  def rpc(pid, request) do
    send pid, {self, request}
    receive do
      response -> response
    end
  end

  def loop do
    receive do
      {from, {:rectangle, width, heigh}} ->
        send from, width * heigh
      {from, {:circle, radius}} ->
        send from, :math.pi * radius * radius
      {from, other} ->
        send from, {:error, other}
    end
    loop
  end
end
