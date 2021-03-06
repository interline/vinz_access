defmodule Vinz.Access.Domains do
  require Ecto.Query

  alias Ecto.Query, as: Q
  alias Vinz.Access.Models.Filter
  alias Vinz.Access.Models.GroupMember

  def get(user_id, resource, mode // :read) do
    base_domain_query = Q.from(f in Filter, select: f.domain)
      |> Q.where([f], f.resource == ^resource)
      |> filter_on_mode(mode)

    global_domains = Q.where(base_domain_query, [f], f.global)
      |> Vinz.Access.Repo.all
      |> join

    user_group_ids = Q.from(m in GroupMember, select: m.vinz_access_group_id)
      |> Q.where([m], m.vinz_access_user_id == ^user_id)
      |> Vinz.Access.Repo.all
    
    group_domains =
      if Enum.count(user_group_ids) > 0 do
        Q.where(base_domain_query, [f], f.vinz_access_group_id in ^user_group_ids)
          |> Vinz.Access.Repo.all
          |> join("or")
      else
        ""
      end

    join([global_domains, group_domains])
  end


  def filter_on_mode(query, :create) do
    Q.where(query, [rule], rule.can_create)
  end
  def filter_on_mode(query, :read) do
    Q.where(query, [rule], rule.can_read)
  end
  def filter_on_mode(query, :update) do
    Q.where(query, [rule], rule.can_update)
  end
  def filter_on_mode(query, :delete) do
    Q.where(query, [rule], rule.can_delete)
  end


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
