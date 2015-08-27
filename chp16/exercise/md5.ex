defmodule MD5 do
  def cks(file) do
    {:ok, bin} = File.read(file)
    :erlang.md5(bin)
    |> digest_to_string
  end

  defp digest_to_string(digest) do
    digest
    |> :erlang.bitstring_to_list
    |> Enum.map(&(:io_lib.format("~2.16.0b", [&1])))
    |> List.flatten
    |> to_string
  end

  @chunk 20000

  def cks_big_file(file) do
    {:ok, s} = File.open(file)
    md5_context = :erlang.md5_init
    cks_big_file(s, 0, md5_context)
    |> digest_to_string
  end
  defp cks_big_file(s, offset, md5_context) do
    case :file.pread(s, offset, @chunk) do
      {:ok, bin} ->
        cks_big_file(s, offset+@chunk, :erlang.md5_update(md5_context, bin))
      :eof ->
        File.close(s)
        md5_context
    end
  end
end
