defmodule Splitmore.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Splitmore.Expenses.Expense
  alias Splitmore.Groups.GroupUser

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string

    has_many :groups, GroupUser

    has_many :expenses, Expense

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
    |> unique_constraint(:email)
  end
end
