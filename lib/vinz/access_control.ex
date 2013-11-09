defmodule Vinz.AccessControl do
  use Ecto.Model

  queryable "vinz_access_control" do
    field :name, :string
    field :resource, :string
    field :global, :boolean
    field :can_create, :boolean
    field :can_read, :boolean
    field :can_write, :boolean
    field :can_delete, :boolean
    belongs_to :group, Vinz.Group
  end
end
