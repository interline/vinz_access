defmodule Vinz.Access.Models do

defmodule User do
  use Ecto.Model

  queryable "vinz_access_user" do
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :binary
  end

  def hash_password(plaintext) do
    
  end
end


defmodule Group do
  use Ecto.Model
  import Ecto.Query

  queryable "vinz_access_group" do
    field :name, :string
    field :comment, :string
  end

  def by_name(name) do
     from g in __MODULE__,
    where: g.name == ^name
  end
end


defmodule GroupMember do
  use Ecto.Model

  queryable "vinz_access_group_member" do
    field :vinz_access_group_id, :integer
    field :vinz_access_user_id, :integer
  end
end


defmodule Right do
  use Ecto.Model

  queryable "vinz_access_right" do
    field :name, :string
    field :resource, :string
    field :global, :boolean
    field :vinz_access_group_id, :integer
    field :can_create, :boolean
    field :can_read, :boolean
    field :can_update, :boolean
    field :can_delete, :boolean
  end
end


defmodule Filter do
  use Ecto.Model

  queryable "vinz_access_filter" do
    field :name, :string
    field :resource, :string
    field :global, :boolean
    field :vinz_access_group_id, :integer
    field :domain, :string
    field :can_create, :boolean, default: false
    field :can_read, :boolean, default: false
    field :can_update, :boolean, default: false
    field :can_delete, :boolean, default: false
  end
end

end