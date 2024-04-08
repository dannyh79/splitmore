defmodule Splitmore.ExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Splitmore.Expenses` context.
  """

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: 42,
        name: "some name"
      })
      |> Splitmore.Expenses.create_expense()

    expense
  end
end
