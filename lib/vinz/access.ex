defmodule Vinz.Access do
  require Ecto.Query

  alias Ecto.Query, as: Q

  alias Vinz.Repo
  alias Vinz.Domains
  alias Vinz.AccessRight
  alias Vinz.GroupMember

  @modes [ :create, :read, :update, :delete ]

  def check!(user_id, resource, mode) when mode in @modes do
    unless can_access?(user_id, resource, mode), do: throw :unauthorized
    true
  end

  def check(user_id, resource, mode) when mode in @modes do
    can_access?(user_id, resource, mode)
  end

  def permit(user_id, resource, mode, action) when mode in @modes and is_function(action, 0) do
    if check(user_id, resource, mode) do
      action.()
    else
      { :error, :unauthorized }
    end
  end

  def permit(user_id, resource, mode, action) when mode in @modes and is_function(action, 1) do
    domain = Domains.get(user_id, resource, mode)
    if check(user_id, resource, mode) || domain do
      action.(domain)
    else
      { :error, :unauthorized }
    end
  end

  def can_create?(user_id, resource), do: can_access?(user_id, resource, :create)
  def can_read?(user_id, resource), do: can_access?(user_id, resource, :read)
  def can_update?(user_id, resource), do: can_access?(user_id, resource, :update)
  def can_delete?(user_id, resource), do: can_access?(user_id, resource, :delete)

  def can_access?(user_id, resource, mode) when mode in @modes do
    user_group_ids = Q.from(m in GroupMember, select: m.vinz_group_id)
      |> Q.where([m], m.vinz_user_id == ^user_id)
      |> Repo.all

    access = Q.from(a in AccessRight)
      |> Q.where([r], r.global or (r.vinz_group_id in ^user_group_ids))
      |> Q.where([r], r.resource == ^resource)
      |> select(mode)
      |> Repo.all
      |> Enum.first

    !!access
  end

  defp select(query, :create), do: Q.select(query, [r], bool_or(r.can_create))
  defp select(query, :read),   do: Q.select(query, [r], bool_or(r.can_read))
  defp select(query, :update), do: Q.select(query, [r], bool_or(r.can_update))
  defp select(query, :delete), do: Q.select(query, [r], bool_or(r.can_delete))
end
