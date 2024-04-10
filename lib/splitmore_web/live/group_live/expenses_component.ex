defmodule SplitmoreWeb.GroupLive.ExpensesComponent do
  use SplitmoreWeb, :live_component

  alias Splitmore.Expenses

  # TODO: avoid unnecessary queries across updates
  @impl true
  def update(%{group_id: id} = _params, socket) do
    socket =
      socket
      |> assign_new(:group_id, fn -> id end)
      |> stream(:expenses, Expenses.list_group_expenses(id))

    {:ok, socket}
  end
end
