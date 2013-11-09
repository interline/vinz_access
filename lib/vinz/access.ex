defmodule Vinz.Access do
  import Ecto.Query

  alias Vinz.Group
  alias Vinz.Rule

  def groups_for_user(user_id) when is_integer(user_id) do
       from g in Group,
      join: m in GroupMember, on: g.id == m.vinz_acl_group and m.vinz_user_id = ^user_id,
    select: g.id
  end

  def domains_for_user(user_id, resource) when is_integer(user_id) do
       from r in Rule
  end
end