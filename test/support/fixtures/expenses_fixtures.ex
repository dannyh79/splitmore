defmodule Splitmore.ExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Splitmore.Expenses` context.
  """
  import Splitmore.UsersFixtures

  @doc """
  Generate a expense. An user is created if there is no user_id in attrs.
  """
  def expense_fixture(attrs \\ %{})

  def expense_fixture(%{user_id: id, paid_by_id: p_id} = attrs)
      when is_binary(id) and is_binary(p_id),
      do: create_expense_with_fallback_attrs(attrs)

  def expense_fixture(attrs) do
    user = user_fixture()

    attrs
    |> Enum.into(%{user_id: user.id, paid_by_id: user.id})
    |> create_expense_with_fallback_attrs()
  end

  defp create_expense_with_fallback_attrs(attrs) do
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
