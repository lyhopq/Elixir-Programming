defmodule Kvs do
  def start do
    Process.register(spawn(&loop/0), :kvs)
  end

  def store(key, value), do: rpc({:store, key, value})

  def lookup(key), do: rpc({:lookup, key})

  def rpc(q) do
    send :kvs, {self, q}
    receive do
      {:kvs, reply} ->
        reply
    end
  end

  def loop do
    receive do
      {from, {:store, key, value}} ->
        Process.put(key, value)
        send from, {:kvs, true}
      {from, {:lookup, key}} ->
        send from, {:kvs, Process.get(key)}
    end
    loop
  end
end
