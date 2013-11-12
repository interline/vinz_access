defmodule Vinz.Access.Test do
  use ExUnit.Case

  import Vinz.Access, only: [ can_create?: 2, can_read?: 2, can_update?: 2, can_delete?: 2, check!: 3 ]

  alias Ecto.Adapters.Postgres

  alias Vinz.Repo
  alias Vinz.User
  alias Vinz.Group
  alias Vinz.GroupMember
  alias Vinz.AccessControl


  setup_all do
    Postgres.begin_test_transaction(Vinz.Repo)

    resource = "access-test-resource"
    user = User.new(username: "test-access", first_name: "Test", last_name: "Access") |> Repo.create
    group = Group.new(name: "access-test", comment: "a group for testing access controll") |> Repo.create
    GroupMember.new(vinz_group_id: group.id, vinz_user_id: user.id) |> Repo.create

    AccessControl.new(name: "test-access-create", resource: resource, global: true, can_create: true) |> Repo.create
    AccessControl.new(name: "test-access-read", resource: resource, global: false, vinz_group_id: group.id, can_read: true) |> Repo.create
    AccessControl.new(name: "test-access-update", resource: resource, global: false, vinz_group_id: group.id, can_update: true) |> Repo.create
    AccessControl.new(name: "test-access-delete", resource: resource, global: true, can_delete: true) |> Repo.create
    AccessControl.new(name: "test-access-group-delete", resource: resource, global: false, vinz_group_id: group.id, can_delete: false)

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
end
