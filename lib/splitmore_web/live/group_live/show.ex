defmodule SplitmoreWeb.GroupLive.Show do
  use SplitmoreWeb, :live_view

  alias Splitmore.Expenses
  alias Splitmore.Groups

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    {:ok, assign(socket, :group_id, id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    group = Groups.get_group!(id)

    {:noreply,
     socket
     |> assign(:group, group)
     |> assign(:page_title, page_title(socket.assigns, group))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    expense = Expenses.get_expense!(id)
    {:ok, _} = Expenses.delete_expense(expense)

    {:noreply, socket}
  end

  defp page_title(%{live_action: :show}, %{name: name}), do: "Show #{name} Expenses"
  defp page_title(%{live_action: :edit}, _), do: "Edit Group"
end
