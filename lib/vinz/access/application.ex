defmodule Vinz.Access.Application do
  use Application.Behaviour

  def start(_type, _args) do
    Vinz.Access.Supervisor.start_link
  end

  def stop(_state), do: :ok
end
