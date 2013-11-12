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

  def query_apis do
    super() ++ [Vinz.Repo.Query.Api]
  end
end

defmodule Vinz.Repo.Query.Api do
  use Ecto.Query.Typespec

  ## Types
  deft boolean

  @doc """
  Aggregate function, returns true if atleast one input value is true.
  See http://www.postgresql.org/docs/9.2/static/functions-aggregate.html
  """
  @aggregate true
  def bool_or(booleans)
  defs bool_or(boolean) :: boolean
end
