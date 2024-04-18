defmodule Splitmore.ExpensesTest do
  use Splitmore.DataCase

  alias Splitmore.Expenses
  alias Splitmore.Expenses.Expense

  import Splitmore.ExpensesFixtures
  import Splitmore.GroupsFixtures
  import Splitmore.UsersFixtures

  @invalid_attrs %{name: nil, amount: nil}

  describe "list_expenses/0" do
    test "returns all expenses" do
      expense = expense_fixture()
      assert Expenses.list_expenses() == [expense]
    end
  end

  describe "list_group_expenses/1" do
    test "returns all expenses of a group" do
      group1 = group_fixture()
      group2 = group_fixture()
      expense = with_paid_by_expense_fixture(%{group_id: group1.id})
      _expense2 = with_paid_by_expense_fixture(%{group_id: group2.id})
      assert Expenses.list_group_expenses(group1.id) == [expense]
    end
  end

  describe "get_expense!/1" do
    test "returns the expense with given id" do
      expense = with_paid_by_expense_fixture()
      assert Expenses.get_expense!(expense.id) == expense
    end
  end

  describe "create_expense/1" do
    test "creates an expense" do
      user = user_fixture()
      valid_attrs = %{name: "some name", amount: 42, user_id: user.id, paid_by_id: user.id}

      assert {:ok, %Expense{} = expense} = Expenses.create_expense(valid_attrs)
      assert expense.name == "some name"
      assert expense.amount == 42
      assert expense.user_id == user.id
      assert expense.paid_by_id == user.id
    end

    test "returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Expenses.create_expense(@invalid_attrs)
    end
  end

  describe "update_expense/2" do
    test "updates an expense" do
      expense = expense_fixture()
      update_attrs = %{name: "some updated name", amount: 43}

      assert {:ok, %Expense{} = expense} = Expenses.update_expense(expense, update_attrs)
      assert expense.name == "some updated name"
      assert expense.amount == 43
    end

    test "returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Expenses.update_expense(expense, @invalid_attrs)

      assert Map.drop(expense, [:paid_by]) ==
               Map.drop(Expenses.get_expense!(expense.id), [:paid_by])
    end
  end

  describe "delete_expense/1" do
    test "deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Expenses.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_expense!(expense.id) end
    end
  end

  describe "change_expense/1" do
    test "returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Expenses.change_expense(expense)
    end
  end

  describe "summarize_group_balances/1" do
    test "returns group balances of a given user" do
      %{id: id} = group_fixture()
      user1 = user_fixture()
      user2 = user_fixture(email: "another@example.com")

      Splitmore.Repo.query!("INSERT INTO groups_users (group_id, user_id) VALUES
        ('#{id}', '#{user1.id}'),
        ('#{id}', '#{user2.id}')
        ")

      expense1 = expense_fixture(user_id: user1.id, paid_by_id: user1.id, group_id: id, amount: 2)

      expense2 =
        expense_fixture(user_id: user1.id, paid_by_id: user2.id, group_id: id, amount: 4200)

      expected = [{user2.email, -(expense2.amount - expense1.amount) / 2}]
      assert expected == Expenses.summarize_group_balances(id, user1)
    end
  end
end
