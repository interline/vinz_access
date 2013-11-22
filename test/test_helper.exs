ExUnit.start
# Vinz.Access.Repo.start_link

defmodule Vinz.Access.TestCase do
  defmacro __using__(_) do
    quote do
      use ExUnit.Case
      alias Ecto.Adapters.Postgres
      alias Vinz.Access.Repo

      def begin do
        Postgres.begin_test_transaction(Repo)
        :ok
      end

      def rollback do
        Postgres.rollback_test_transaction(Repo)
        :ok
      end
    end
  end
end
