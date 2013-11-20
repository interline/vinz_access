defmodule Vinz.Domain.Test do
  use ExUnit.Case

  alias Vinz.User
  alias Vinz.Group
  alias Vinz.GroupMember
  alias Vinz.Repo
  alias Vinz.AccessFilter, as: Filter

  setup_all do
    resource = "domain-test-resource"
    u = User.new(username: "domain-test", first_name: "Domain", last_name: "Test") |> Repo.create
    g = Group.new(name: "domain-test", description: "a group to test user domains") |> Repo.create
    m = GroupMember.new(vinz_group_id: g.id, vinz_user_id: u.id) |> Repo.create
    Filter.new(name: "global-test-rule", resource: resource, global: true, domain: "G", can_read: true) |> Repo.create
    Filter.new(name: "group-specific-rule-read", resource: resource, global: false, vinz_group_id: g.id, domain: "GSR", can_read: true) |> Repo.create
    Filter.new(name: "group-specific-rule-write", resource: resource, global: false, vinz_group_id: g.id, domain: "U", can_update: true) |> Repo.create
    Filter.new(name: "group-specific-rule-write", resource: resource, global: false, vinz_group_id: g.id, domain: "C", can_create: true) |> Repo.create
    Filter.new(name: "group-specific-rule-write", resource: resource, global: false, vinz_group_id: g.id, domain: "D", can_delete: true) |> Repo.create
    { :ok, [ user: u, group: g, group_member: m, resource: resource ] }
  end

  teardown_all context do
    Repo.delete_all(Filter)
    Repo.delete(context[:group_member])
    Repo.delete(context[:group])
    Repo.delete(context[:user])
    :ok
  end

  test :join_domains do
    import Vinz.Domains, only: [ join: 1, join: 2 ]
    
    assert "" == join([])
    assert "a" == join(%w(a))
    assert "(a) and (b)" == join(%w(a b))
    assert "(a) and ((b) or (c))" == join([join(%w(a)), join(%w(b c), "or")])
  end

  test :getting_user_domains, context do
    user = Keyword.get(context, :user)
    resource = Keyword.get(context, :resource)
    assert "(G) and (GSR)" == Vinz.Domains.get(user.id, resource)
    assert "U" == Vinz.Domains.get(user.id, resource, :update)
    assert "C" == Vinz.Domains.get(user.id, resource, :create)
    assert "D" == Vinz.Domains.get(user.id, resource, :delete)  
  end
end
