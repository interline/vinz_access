defmodule Vinz.AccessRule do
  use Ecto.Model
  import Ecto.Query

  queryable "vinz_access_rule" do
    field :name, :string
    field :resource, :string
    field :global, :boolean
    field :domain, :string
    field :can_create, :boolean
    field :can_read, :boolean
    field :can_write, :boolean
    field :can_delete, :boolean
    belongs_to :group, Vinz.Group
  end
end
