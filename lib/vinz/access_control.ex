defmodule Vinz.AccessControl do
  use Ecto.Model

  queryable "vinz_access_control" do
    field :name, :string
    field :resource, :string
    field :global, :boolean
    field :vinz_group_id, :integer
    field :can_create, :boolean
    field :can_read, :boolean
    field :can_update, :boolean
    field :can_delete, :boolean
  end
end
