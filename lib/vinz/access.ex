defmodule Vinz.Access do
  require Ecto.Query

  alias Ecto.Query, as: Q

  alias Vinz.Repo
  alias Vinz.GroupMember
  alias Vinz.AccessControl

  @modes [ :create, :read, :update, :delete ]

  def check!(user_id, resource, mode) when mode in @modes do
    unless can_access?(user_id, resource, mode), do: throw :unauthorized
    true
  end

  def check(user_id, resource, mode) when mode in @modes do
    can_access?(user_id, resource, mode)
  end

  def can_create?(user_id, resource), do: can_access?(user_id, resource, :create)
  def can_read?(user_id, resource), do: can_access?(user_id, resource, :read)
  def can_update?(user_id, resource), do: can_access?(user_id, resource, :update)
  def can_delete?(user_id, resource), do: can_access?(user_id, resource, :delete)

  def can_access?(user_id, resource, mode) when mode in @modes do
    user_group_ids = Q.from(m in GroupMember, select: m.vinz_group_id)
      |> Q.where([m], m.vinz_user_id == ^user_id)
      |> Repo.all

    access = Q.from(ac in AccessControl)
      |> Q.where([ac], ac.global or (ac.vinz_group_id in ^user_group_ids))
      |> Q.where([ac], ac.resource == ^resource)
      |> select(mode)
      |> Repo.all
      |> Enum.first

    !!access
  end

  defp select(query, :create), do: Q.select(query, [ac], bool_or(ac.can_create))
  defp select(query, :read),   do: Q.select(query, [ac], bool_or(ac.can_read))
  defp select(query, :update), do: Q.select(query, [ac], bool_or(ac.can_update))
  defp select(query, :delete), do: Q.select(query, [ac], bool_or(ac.can_delete))
end