defmodule Libfind do
  require Record
  Record.defrecordp :file_info, Record.extract(:file_info, from_lib: "kernel/include/file.hrl")

  def files(dir, re, flag \\ true) do
    {:ok, rel} = re
    |> to_char_list
    |> :xmerl_regexp.sh_to_awk
    |> to_string
    |> Regex.compile

    files(dir, rel, flag, fn(file, acc) -> [file | acc] end, [])
    |> Enum.reverse
  end

  def files(dir, reg, recursive, fun, acc) do
    case File.ls(dir) do
      {:ok, files_} ->
        find_files(files_, dir, reg, recursive, fun, acc)
      {:error, _} ->
        acc
    end
  end

  defp find_files([file | rest], dir, reg, recursive, fun, acc0) do
    full_name = Path.join([dir, file])
    case file_type(full_name) do
      :regular ->
        if Regex.match?(reg, full_name) do
          acc = fun.(full_name, acc0)
          find_files(rest, dir, reg, recursive, fun, acc)
        else
          find_files(rest, dir, reg, recursive, fun, acc0)
        end
      :directory ->
        if recursive do
          acc1 = files(full_name, reg, recursive, fun, acc0)
          find_files(rest, dir, reg, recursive, fun, acc1)
        else
          find_files(rest, dir, reg, recursive, fun, acc0)
        end
      :error ->
        find_files(rest, dir, reg, recursive, fun, acc0)
    end
  end
  defp find_files([], _, _, _, _, acc), do: acc

  defp file_type(file) do
    case :file.read_file_info(file) do
      {:ok, file_info(type: type)} ->
        case type do
          :regular ->
            :regular
          :directory ->
            :directory
          _ ->
            :error
        end
      _ ->
        :error
    end
  end
end
