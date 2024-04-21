defmodule Splitmore.BookKeeperTest do
  use Splitmore.DataCase

  alias Splitmore.BookKeeper

  import Splitmore.ExpensesFixtures
  import Splitmore.GroupsFixtures
  import Splitmore.UsersFixtures

  describe "summarize_group_balances/1" do
    test "returns one group balance of a given user" do
      %{id: id} = group_fixture()
      [u1, u2] = users = for _ <- 1..2, do: user_fixture()

      assoc_users_with_group(id, Enum.map(users, & &1.id))

      [e1, e2] =
        expenses =
        [
          %{user_id: u1.id, paid_by_id: u1.id, amount: 2},
          %{user_id: u1.id, paid_by_id: u2.id, amount: 4200}
        ]
        |> Enum.map(&Map.put(&1, :group_id, id))
        |> Enum.map(&with_paid_by_expense_fixture/1)

      expected = [{u2.email, -(e2.amount - e1.amount) / 2}]

      assert expected == BookKeeper.calculate_balances(expenses, users, u1)
    end

    test "returns one group balance of a given user no matter their index in people involved" do
      %{id: id} = group_fixture()
      [u2, u1] = users = for _ <- 1..2, do: user_fixture()

      assoc_users_with_group(id, Enum.map(users, & &1.id))

      [e1, e2] =
        expenses =
        [
          %{user_id: u1.id, paid_by_id: u1.id, amount: 2},
          %{user_id: u1.id, paid_by_id: u2.id, amount: 4200}
        ]
        |> Enum.map(&Map.put(&1, :group_id, id))
        |> Enum.map(&with_paid_by_expense_fixture/1)

      expected = [{u2.email, -(e2.amount - e1.amount) / 2}]

      assert expected == BookKeeper.calculate_balances(expenses, users, u1)
    end

    test "returns multiple group balances of a given user" do
      %{id: id} = group_fixture()
      [u1, u2, u3] = users = for _ <- 1..3, do: user_fixture()

      assoc_users_with_group(id, Enum.map(users, & &1.id))

      [e1, e2] =
        expenses =
        [
          %{user_id: u1.id, paid_by_id: u1.id, amount: 3},
          %{user_id: u1.id, paid_by_id: u2.id, amount: 6300}
        ]
        |> Enum.map(&Map.put(&1, :group_id, id))
        |> Enum.map(&with_paid_by_expense_fixture/1)

      expected = [
        {u3.email, e1.amount / 3},
        {u2.email, -(e2.amount - e1.amount) / 3}
      ]

      assert expected == BookKeeper.calculate_balances(expenses, users, u1)
    end

    test "returns empty group balances of a given user" do
      %{id: id} = group_fixture()
      [u1, u2] = users = for _ <- 1..2, do: user_fixture()

      assoc_users_with_group(id, Enum.map(users, & &1.id))

      expenses =
        [
          %{user_id: u1.id, paid_by_id: u1.id, amount: 2},
          %{user_id: u1.id, paid_by_id: u2.id, amount: 2}
        ]
        |> Enum.map(&Map.put(&1, :group_id, id))
        |> Enum.map(&with_paid_by_expense_fixture/1)

      assert [] == BookKeeper.calculate_balances(expenses, users, u1)
    end
  end

  defp assoc_users_with_group(group_id, user_ids) do
    rows = user_ids |> Enum.map_join(",", &"('#{group_id}', '#{&1}')")
    Splitmore.Repo.query!("INSERT INTO groups_users (group_id, user_id) VALUES " <> rows)
  end
end
