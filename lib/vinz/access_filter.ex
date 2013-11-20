defmodule Vinz.AccessFilter do
  use Ecto.Model

  queryable "vinz_access_filter" do
    field :name, :string
    field :resource, :string
    field :global, :boolean
    field :vinz_group_id, :integer
    field :domain, :string
    field :can_create, :boolean, default: false
    field :can_read, :boolean, default: false
    field :can_update, :boolean, default: false
    field :can_delete, :boolean, default: false
  end
end
