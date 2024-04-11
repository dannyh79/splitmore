defmodule Splitmore.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset
  alias Splitmore.Groups.Group
  alias Splitmore.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "expenses" do
    field :name, :string
    field :amount, :integer

    belongs_to :group, Group
    belongs_to :user, User
    belongs_to :paid_by, User, foreign_key: :paid_by_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:name, :amount, :group_id, :user_id, :paid_by_id])
    |> validate_required([:name, :amount, :user_id, :paid_by_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:paid_by_id)
  end
end
