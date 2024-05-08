defmodule Splitmore.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset
  alias Splitmore.Groups.GroupUser

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "groups" do
    field :name, :string

    has_many :users, GroupUser

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
