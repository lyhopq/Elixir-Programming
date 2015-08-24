defmodule Libmisc do
  def sleep(t) do
    receive do
    after t ->
      true
    end
  end

  def flush_buffer do
    receive do
      _any ->
        flush_buffer
    after 0 ->
      true
    end
  end

  def priority_receive do
    receive do
      {:alarm, x}=alarm ->
        alarm
    after 0 ->
      receive do
        any ->
          any
      end
    end
  end
end
