defmodule FileServer do
  def start(dir), do: spawn(__MODULE__, :loop, [dir])

  def loop(dir) do
    receive do
      {client, :list_dir} ->
        send client, {self, File.ls(dir)}
      {client, {:get_file, file}} ->
        send client, {self, File.read(Path.join(dir, file))}
      {_client, {:put_file, file, content}} ->
        {file, content}
    end
    loop(dir)
  end
end

FileServer.start(".")
