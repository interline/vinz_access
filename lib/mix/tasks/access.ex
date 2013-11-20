defmodule Mix.Tasks.Vinz.Access.Load do
  use Mix.Task

  @shortdoc "Load a bunch of access records from from a file"
  def run([path]) do
    unless File.exists?(path), do: Mix.Shell.IO.error "File #{path} not found"
    :application.load(:vinz_access)
    Vinz.Repo.start_link
    { :ok, contents } = File.read(path)
    Vinz.Access.Load.load_string(contents)
  end
end