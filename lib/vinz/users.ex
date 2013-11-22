defmodule Vinz.Users do
  @resource "vinz.users"

  alias Vinz.Access
  alias Vinz.Repo
  alias Vinz.User

  def create(creator_id, vals) do
    Access.permit creator_id, @resource, :create, fn ->
      user = User.new(vals)
      case User.validate(user) do
        { :ok, user } -> Repo.create(user)
        { :error, errors } -> { :error, errors }
      end
    end
  end

  def delete(deletor_id, user_id) do
    Access.permit deletor_id, @resource, :delete, fn ->
      if user = Repo.find(User, user_id) do
        Repo.delete(user)
      else
        { :error, :not_found }
      end
    end
  end
end
