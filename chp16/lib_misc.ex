defmodule Libmisc do
  require Record
  Record.defrecordp :file_info, Record.extract(:file_info, from_lib: "kernel/include/file.hrl")

  def consult(file) do
    case File.open(file, [:read]) do
      {:ok, s} ->
        val = consult1(s)
        File.close(s)
        {:ok, val}
      {:error, why} ->
        {:error, why}
    end
  end

  defp consult1(s) do
    case :io.read(s, '') do
      {:ok, term} -> [term | consult1(s)]
      :eof -> []
      :error -> :error
    end
  end

  def dump(file, term) do
    out = file <> ".tmp"
    IO.puts "** dumping to #{out}"
    File.write(out, inspect(term))
  end

  def unconsult(file, term) do
    {:ok, s} = File.open(file, [:write])
    term
    |> Enum.each(fn x -> :io.format(s, "~p.~n", [x]) end)
    File.close(s)
  end

  def file_size_and_type(file) do
    case :file.read_file_info(file) do
      {:ok, facts} ->
        file_info(type: type, size: size) = facts
        {type, size}
      _ ->
        :error
    end
  end

  def ls(dir) do
    {:ok, files} = File.ls(dir)
    files
    |> Enum.sort
    |> Enum.map(fn file -> {file, file_size_and_type(file)} end)
  end
end
