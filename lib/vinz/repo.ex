defmodule Vinz.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url do
    case :application.get_env(:vinz_access, :repo_url) do
      { :ok, url } -> url
      _other ->
        IO.inspect(:application.which_applications)
        raise "`vinz_access` application environment variable `repo_url` needs to be set in the config"
    end
  end
end
