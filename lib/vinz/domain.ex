defmodule Vinz.Domains do
  def join(domains, op // "and") do
    domains |> Enum.filter(&(String.length(&1) > 0)) |> wrap |> Enum.join(" #{op} ")
  end

  def wrap(domains) do
    case domains do
      [domain] -> [domain]
      domains  -> Enum.map(domains, &("(" <> &1 <> ")"))
    end
  end
end