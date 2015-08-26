defmodule ScavengeUrls do
  def urls2htmlFile(urls, file) do
    File.write(file, urls2html(urls))
  end

  def bin2urls(bin), do: gather_urls(to_char_list(bin), [])

  defp urls2html(urls), do: [h1("Urls"), make_list(urls)]

  defp h1(title), do: ["<h1>", title, "</h1>\n"]

  defp make_list(list) do
    ["<ul>\n",
      Enum.map(list, fn l -> ["<li>", l, "</li>\n"] end),
     "</ul>\n"]
  end

  defp gather_urls('<a href' ++ rest, list) do
    {url, t1} = collect_url_body(rest, Enum.reverse('<a href'))
    IO.puts "#{url}"
    gather_urls(t1, [url | list])
  end
  defp gather_urls([_ | t], list) do
    gather_urls(t, list)
  end
  defp gather_urls([], list), do: list

  defp collect_url_body('</a>' ++ t, acc), do: {Enum.reverse(acc, '</a>'), t}
  defp collect_url_body([h | t], acc), do: collect_url_body(t, [h | acc])
  defp collect_url_body([], _), do: {[], []}
end
