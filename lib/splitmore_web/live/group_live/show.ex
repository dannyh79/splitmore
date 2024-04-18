defmodule SplitmoreWeb.GroupLive.Show do
  use SplitmoreWeb, :live_view

  alias Splitmore.Expenses
  alias Splitmore.Groups

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    current_user = socket.assigns.current_user
    balances = Expenses.summarize_group_balances(id, current_user)

    socket =
      socket
      |> assign(
        group_id: id,
        summary: {current_user, balances}
      )

    {:ok, socket}
  end

  defp summary_section(assigns) do
    ~H"""
    <% {%{email: current_user}, balances} = assigns.summary %>
    <div id={@id}>
      <.header>Summary</.header>
      <ul>
        <li :for={{name, balance} <- balances} class="list-disc" id={"balance-#{name}"}>
          <%= if balance > 0 do %>
            <b><%= name %></b> owes <b><%= current_user %></b>
          <% else %>
            <b><%= current_user %></b> owes <b><%= name %></b>
          <% end %>
          &nbsp;<span class="ml-2"><%= to_currency(balance) %></span>
        </li>
      </ul>
    </div>
    """
  end

  # TODO: render decimals
  defp to_currency(amount) do
    amount
    |> round()
    |> abs()
    |> Integer.to_charlist()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.join(",")
    |> String.reverse()
    |> (&"$#{&1}").()
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

    current_user = socket.assigns.current_user
    balances = Expenses.summarize_group_balances(socket.assigns.group_id, current_user)

    socket = assign(socket, summary: {current_user, balances})
    {:noreply, socket}
  end

  defp page_title(%{live_action: :show}, %{name: name}), do: "Show #{name} Expenses"
  defp page_title(%{live_action: :edit}, _), do: "Edit Group"
end
