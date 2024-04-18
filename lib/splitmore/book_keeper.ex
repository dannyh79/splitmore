defmodule Splitmore.BookKeeper do
  @moduledoc """
  This is a book keeper that calculates balances.
  """

  def calculate_balances(expenses, people_involved, %{email: me}) do
    headcount = length(people_involved)

    others =
      people_involved
      |> Enum.drop_while(fn e -> e.email == me end)
      |> Enum.map(fn e -> e.email end)

    map = Map.new(others, &{&1, 0})

    balances =
      Enum.reduce(expenses, map, fn e, acc ->
        share = e.amount / headcount

        paid_by = e.paid_by.email

        if paid_by != me do
          Map.put(acc, paid_by, Map.get(acc, paid_by, 0) - share)
        else
          update_balances_for_others(acc, others, share)
        end
      end)
      |> Enum.filter(&(elem(&1, 1) != 0))
      |> Enum.sort(&(elem(&1, 1) > elem(&2, 1)))

    balances
  end

  defp update_balances_for_others(acc, others, share) do
    Enum.reduce(others, acc, fn other, a ->
      Map.update!(a, other, &(&1 + share))
    end)
  end
end
