defmodule IDv1 do
  require Libmisc
  require :lib_find

  def dir(dir_) do
    files = :lib_find.files(dir_, '*.mp3', true)
    |> Enum.map(fn file -> {file, read_id3_tag(file)} end)
    |> Enum.filter(fn {_, :error} -> false
                      _ -> true end
                  )
    Libmisc.dump("mp3data", files)
  end

  defp read_id3_tag(file) do
    case File.open(file, [:read, :binary, :raw]) do
      {:ok, s} ->
        size = :filelib.file_size(file)
        {:ok, b2} = :file.pread(s, size-128, 128)
        File.close(s)
        parse_v1_tag(b2)
      _ ->
        :error
    end
  end

  defp parse_v1_tag(<<"TAG",
                    title::binary-size(30),
                    artist::binary-size(30),
                    album::binary-size(30),
                    _year::binary-size(4),
                    _comment::binary-size(28),
                    0::8,
                    track::8,
                    _genre::8>>) do
    {"ID3v1.1",
     [{:track, track}, {:title, trim(title)},
      {:artist, trim(artist)}, {:album, trim(album)}]
    }
  end
  defp parse_v1_tag(_), do: :error

  defp trim(bin) do
    bin
    |> String.rstrip
    |> String.rstrip(0)
  end
end
