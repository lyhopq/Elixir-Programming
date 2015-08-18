defmodule JsonCfg do
  def read do
    :jiffy.decode(File.read!(Path.join(__DIR__, "sample.json")))
    |> elem(0)
  end
end
