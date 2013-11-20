defmodule Vinz.Group do
  use Ecto.Model
  import Ecto.Query

  queryable "vinz_group" do
    field :name, :string
    field :comment, :string
  end
end

defmodule Vinz.GroupMember do
  use Ecto.Model

  queryable "vinz_group_member" do
    field :vinz_group_id, :integer
    field :vinz_user_id, :integer
  end
end