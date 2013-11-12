defmodule Vinz.Users do
  @resource "vinz.users"

  alias Vinz.Access
  alias Vinz.Repo
  alias Vinz.User

  def create(creator_id, vals) do
    unless Access.check(creator_id, @resource, :create) do
      { :error, :unauthorized }
    else
      user = User.new(vals)
      case User.validate(user) do
        { :ok, user } -> Repo.create(user)
        { :error, errors } -> { :error, errors }
      end
    end
  end

  def delete(deletor_id, user_id) do
    unless Access.check(deletor_id, @resource, :delete) do
      { :error, :unauthroized }
    else
      if user = Repo.find(User, user_id) do
        Repo.delete(user)
      else
        { :error, :not_found }
      end
    end
  end
end
