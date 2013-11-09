defmodule Vinz.User do
  use Ecto.Model

  queryable "vinz_user" do
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :binary
  end
end
