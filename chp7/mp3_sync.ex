defmodule Mp3Sync do
  def find_sync(bin, n) do
    case is_header(bin, n) do
      {:ok, len1, _} ->
        case is_header(bin, n+len1) do
          {:ok, len2, _} ->
            case is_header(bin, n+len1+len2) do
              {:ok, _, _} ->
                {:ok, n}
              :error ->
                find_sync(bin, n+1)
            end
          :error ->
            find_sync(bin, n+1)
        end
      :error ->
        find_sync(bin, n+1)
    end
  end

  defp is_header(bin, n), do: unpack_header(get_word(bin, n))

  defp get_word(bin, n) do
    {_, <<c::binary-size(4), _::binary>>} = :erlang.split_binary(bin, n)
    c
  end

  defp unpack_header(h) do
    try do
      decode_header(h)
    catch
      _, _ -> :error
    end
  end

  defp decode_header(<<0b11111111111::size(11), b::size(2), c::size(2),
                     _D::size(1), e::size(4), f::size(2), g::size(1), bits::size(9)>>) do
    vsn = case b do
            0 -> {2, 5}
            1 -> :erlang.exit(:bad_vsn)
            2 -> 2
            3 -> 1
    end
    layer = case c do
              0 -> :erlang.exit(:bad_layer)
              1 -> 3
              2 -> 2
              3 -> 1
    end
    ## protection = D
    bit_rate = bitrate(vsn, layer, e) * 1000
    sample_rate = samplerate(vsn, f)
    padding = g
    frame_length = framelength(layer, bit_rate, sample_rate, padding)
    if frame_length < 21 do
      :erlang.exit(:frame_size)
    else
      {:ok, frame_length, {layer, bit_rate, sample_rate, vsn, bits}}
    end
  end
  defp decode_header(_), do: :erlang.exit(:bad_header)

  defp bitrate(_, _, 15), do: :erlang.exit(1)
  defp bitrate(1, 1, e), do: elem({:free,32,64,96,128,160,192,224,256,288,
		                               320,352,384,416,448}, e+1)
  defp bitrate(1, 2, e), do: elem({:free,32,48,56,64,80,96,112,128,160,
		                               192,224,256,320,384}, e+1)
  defp bitrate(1, 3, e), do: elem({:free,32,40,48,56,64,80,96,112,128,160,192,
		                               224,256,320}, e+1)
  defp bitrate(2, 1, e), do: elem({:free,32,48,56,64,80,96,112,128,144,160,
		                               176,192,224,256}, e+1)
  defp bitrate(2, 2, e), do: elem({:free,8,16,24,32,40,48,56,64,80,96,112,
		                                  128,144,160}, e+1);
  defp bitrate(2, 3, e), do: bitrate(2, 2, e)
  defp bitrate({2,5}, l, e), do: bitrate(2, l, e)

  defp samplerate(1, 0), do: 44100
  defp samplerate(1, 1), do: 48000
  defp samplerate(1, 2), do: 32000
  defp samplerate(2, 0), do: 22050
  defp samplerate(2, 1), do: 24000
  defp samplerate(2, 2), do: 16000
  defp samplerate({2,5}, 0), do: 11025
  defp samplerate({2,5}, 1), do: 12000
  defp samplerate({2,5}, 2), do: 8000

  defp framelength(1, bit_rate, sample_rate, padding) do
    (div(12*bit_rate, sample_rate) + padding) * 4
  end
  defp framelength(_, bit_rate, sample_rate, padding) do
    div(144 * bit_rate, sample_rate) + padding
  end
end
