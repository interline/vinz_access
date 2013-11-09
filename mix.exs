defmodule Vinz.Access.Mixfile do
  use Mix.Project

  def project do
    [ app: :vinz_access,
      version: "0.0.1",
      elixir: "~> 0.11.1",
      deps: deps ]
  end

  def application do
    [ env: env(Mix.env) ]
  end

  defp env(:prod), do: []
  defp env(_), do: [ {:repo_url, "ecto://vinz@localhost/vinz"} ]

  defp deps do
    [ { :ecto, github: "elixir-lang/ecto" },
      { :postgrex, github: "ericmj/postgrex" } ]
  end
end
