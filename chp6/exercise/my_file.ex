defmodule MyFile do
  def read(file) do
    try do
      {:ok, bin} = File.read(file)
      bin
    catch
      :error, _ ->
        throw "#{file} can't read!"
    end
  end
end
