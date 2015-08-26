defmodule DistDemo do
  def start(node) do
    :erlang.spawn(node, &loop/0)
  end

  def rpc(pid, m, f, a) do
    send pid, {:rpc, self, m, f, a}
    receive do
      {^pid, response} ->
        response
    end
  end

  defp loop do
    receive do
      {:rpc, pid, m, f, a} ->
        send pid, {self, apply(m, f, a)}
        loop
    end
  end
end
