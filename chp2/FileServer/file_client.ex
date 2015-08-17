defmodule FileClient do
  def ls(server) do
    send server, {self, :list_dir}
    receive do
      {^server, file_list} ->
        file_list
    end
  end

  def get_file(server, file) do
    send server, {self, {:get_file, file}}
    receive do
      {^server, content} ->
        content
    end
  end

  def put_file(server, file) do
    send server, {self, {:put_file, Path.basename(file), File.read(file)}}
  end
end
