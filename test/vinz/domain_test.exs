defmodule Vinz.Domain.Test do
  use Vinz.Access.TestCase
  
  alias Vinz.Access.Domains
  alias Vinz.Access.Repo
  alias Vinz.Access.Models.Filter
  alias Vinz.Access.Models.User
  alias Vinz.Access.Models.Group
  alias Vinz.Access.Models.GroupMember

  setup_all do
    begin
    resource = "domain-test-resource"
    u = User.new(username: "domain-test", first_name: "Domain", last_name: "Test") |> Repo.create
    g = Group.new(name: "domain-test", description: "a group to test user domains") |> Repo.create
    m = GroupMember.new(vinz_access_group_id: g.id, vinz_access_user_id: u.id) |> Repo.create
    Filter.new(name: "global-test-filter", resource: resource, global: true, domain: "G", can_read: true) |> Repo.create
    Filter.new(name: "group-specific-filter-read", resource: resource, global: false, vinz_access_group_id: g.id, domain: "GSR", can_read: true) |> Repo.create
    Filter.new(name: "group-specific-filter-write-u", resource: resource, global: false, vinz_access_group_id: g.id, domain: "U", can_update: true) |> Repo.create
    Filter.new(name: "group-specific-filter-write-c", resource: resource, global: false, vinz_access_group_id: g.id, domain: "C", can_create: true) |> Repo.create
    Filter.new(name: "group-specific-filter-write-d", resource: resource, global: false, vinz_access_group_id: g.id, domain: "D", can_delete: true) |> Repo.create
    { :ok, [ user: u, group: g, group_member: m, resource: resource ] }
  end

  teardown_all do: rollback

  test :join_domains do
    import Domains, only: [ join: 1, join: 2 ]
    
    assert "" == join([])
    assert "a" == join(%w(a))
    assert "(a) and (b)" == join(%w(a b))
    assert "(a) and ((b) or (c))" == join([join(%w(a)), join(%w(b c), "or")])
  end

  test :getting_user_domains, context do
    user = Keyword.get(context, :user)
    resource = Keyword.get(context, :resource)
    assert "(G) and (GSR)" == Domains.get(user.id, resource)
    assert "U" == Domains.get(user.id, resource, :update)
    assert "C" == Domains.get(user.id, resource, :create)
    assert "D" == Domains.get(user.id, resource, :delete)
    # user with no groups...
    assert "G" == Domains.get(0, resource, :read)
  end
end
