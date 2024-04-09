defmodule Splitmore.ExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Splitmore.Expenses` context.
  """
  import Splitmore.UsersFixtures

  @doc """
  Generate a expense.
  """
  # TODO: remove dependency user_fixture()
  def expense_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: 42,
        name: "some name",
        user_id: user.id
      })
      |> Splitmore.Expenses.create_expense()

    expense
  end
end
