defmodule Vinz.Access.Test do
  use ExUnit.Case

  import Vinz.Access, only: [ can_create?: 2, can_read?: 2, can_update?: 2, can_delete?: 2, check!: 3, permit: 4 ]

  alias Ecto.Adapters.Postgres

  alias Vinz.Repo
  alias Vinz.User
  alias Vinz.Group
  alias Vinz.GroupMember
  alias Vinz.AccessRight
  alias Vinz.AccessFilter


  setup_all do
    Postgres.begin_test_transaction(Vinz.Repo)

    resource = "access-test-resource"
    user = User.new(username: "test-access", first_name: "Test", last_name: "Access") |> Repo.create
    group = Group.new(name: "access-test", comment: "a group for testing access controll") |> Repo.create
    GroupMember.new(vinz_group_id: group.id, vinz_user_id: user.id) |> Repo.create

    AccessRight.new(name: "test-access-create", resource: resource, global: true, can_create: true) |> Repo.create
    AccessRight.new(name: "test-access-read", resource: resource, global: false, vinz_group_id: group.id, can_read: true) |> Repo.create
    AccessRight.new(name: "test-access-update", resource: resource, global: false, vinz_group_id: group.id, can_update: true) |> Repo.create
    AccessRight.new(name: "test-access-delete", resource: resource, global: true, can_delete: true) |> Repo.create
    AccessRight.new(name: "test-access-group-delete", resource: resource, global: false, vinz_group_id: group.id, can_delete: false)
    AccessFilter.new(name: "test-access-read-rilter-a", resource: resource, global: false, domain: "a", vinz_group_id: group.id, can_read: true) |> Repo.create
    AccessFilter.new(name: "test-access-read-rilter-b", resource: resource, global: false, domain: "b", vinz_group_id: group.id, can_read: true) |> Repo.create
    { :ok, [ user: user, resource: resource ] }
  end
  
  teardown_all do
    Postgres.rollback_test_transaction(Vinz.Repo)
    :ok
  end

  test :user_access, ctx do
    id = ctx[:user].id
    resource = ctx[:resource]
    assert can_create? id, resource
    assert can_read? id, resource
    assert can_update? id, resource
    assert can_delete? id, resource

    refute can_create? id, "foo"
    refute can_read? id, "foo"
    refute can_update? id, "foo"
    refute can_delete? id, "foo"
  end

  test :check!, ctx do
    id = ctx[:user].id
    resource = ctx[:resource]
    
    assert check!(id, resource, :create)
    
    try do
      check!(id, "foo", :create)
      assert false
    catch
      :throw, :unauthorized ->
        assert true
    end
  end

  test :permit, ctx do
    id = ctx[:user].id
    resource = ctx[:resource]

    assert permit(id, resource, :delete, fn -> true end)
    { :error, :unauthorized } = permit(id, "no-resource", :read, fn -> true end)
    domain = Vinz.Domains.get(id, resource, :read)
    ^domain = permit(id, resource, :read, fn(d) -> d end)
  end

  test :load do
    { resp, [] } = Vinz.Access.Load.load_string(%S([
      group("test load group", "just a group to test loading"),
      right("global rights to load resource", "load", [ :read, :create ]),
      right("test load group rights to load resource", "load", "test load group", [ :create, :read, :update, :delete ]),
      filter("global filter to load resource", "load", "a == b", [ :create, :read ]),
      filter("test load group filter to load resource", "load", "test load group", "a == b", [ :delete, :update ])
    ]))
    group = Enum.first(resp)
    group_id = group.id
    [ 
      Group.Entity[],
      AccessRight.Entity[id: _, name: "global rights to load resource", resource: "load", global: true, can_read: true, can_create: true, can_delete: false, can_update: false ],
      AccessRight.Entity[id: _, name: "test load group rights to load resource", resource: "load", global: false, vinz_group_id: ^group_id, can_read: true, can_create: true, can_delete: true, can_update: true ],
      AccessFilter.Entity[id: _, name: "global filter to load resource", resource: "load", global: true, domain: "a == b", can_create: true, can_read: true, can_update: false, can_delete: false ],
      AccessFilter.Entity[id: _, name: "test load group filter to load resource", resource: "load", global: false, vinz_group_id: ^group_id, domain: "a == b", can_create: false, can_read: false, can_delete: true, can_update: true ]
    ] = resp
  end
end
