defmodule Vinz.Access.Load do
  alias Vinz.Access.Repo
  alias Vinz.Access.Models.Group
  alias Vinz.Access.Models.Right
  alias Vinz.Access.Models.Filter

  def load_string(string) when is_binary(string) do
    Code.eval_string(string, [], [ delegate_locals_to: __MODULE__ ])
  end

  def group(name, comment) do
    Group.Entity[name: name, comment: comment] |> Repo.create
  end

  def right(name, resource, modes) do
    create? = :create in modes
    read?   = :read in modes
    update? = :update in modes
    delete? = :delete in modes
    Right.Entity[name: name, resource: resource, global: true,
      can_create: create?, can_read: read?, can_update: update?, can_delete: delete? ]
    |> Repo.create
  end

  def right(name, resource, group_name, modes) do
    group_id = group_id!(group_name)
    create? = :create in modes
    read?   = :read in modes
    update? = :update in modes
    delete? = :delete in modes
    Right.Entity[name: name, resource: resource, global: false, vinz_group_id: group_id,
      can_create: create?, can_read: read?, can_update: update?, can_delete: delete? ]
    |> Repo.create
  end

  def filter(name, resource, domain, modes) do
    create? = :create in modes
    read?   = :read in modes
    update? = :update in modes
    delete? = :delete in modes
    Filter.Entity[name: name, resource: resource, global: true, domain: domain,
      can_create: create?, can_read: read?, can_update: update?, can_delete: delete? ]
    |> Repo.create
  end

  def filter(name, resource, group_name, domain, modes) do
    group_id = group_id!(group_name)
    create? = :create in modes
    read?   = :read in modes
    update? = :update in modes
    delete? = :delete in modes
    Filter.Entity[name: name, resource: resource, global: false, vinz_group_id: group_id, domain: domain,
      can_create: create?, can_read: read?, can_update: update?, can_delete: delete? ]
    |> Repo.create
  end

  defp group_id!(name) do
    group = Process.get({ :group, name })
    unless group do
      group = Repo.all(Group.by_name(name)) |> Enum.first
      unless group, do: raise "Group #{name} was not found"
      Process.put({ :group, name }, group)
    end
    group.id
  end
end