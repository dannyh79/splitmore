defmodule Splitmore.Groups.GroupUser do
  @moduledoc """
  The schema that associates groups and users.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Splitmore.Accounts.User
  alias Splitmore.Groups.Group

  @primary_key false
  @foreign_key_type :binary_id
  schema "groups_users" do
    field :role, Ecto.Enum, values: [default: 0, admin: 1], default: :default

    belongs_to :group, Group
    belongs_to :user, User
  end

  @doc false
  def changeset(group_user, attrs) do
    group_user
    |> cast(attrs, [:group_id, :user_id, :role])
    |> validate_required([:group_id, :user_id])
    |> unique_constraint([:group_id, :user_id])
  end

  def admin?(role) do
    role == :admin
  end
end
