defmodule SplitmoreWeb.GroupLive.Show do
  use SplitmoreWeb, :live_view

  alias Splitmore.Expenses
  alias Splitmore.Groups

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    summary = {socket.assigns.current_user.email, [{"another@example.com", -2_099}]}

    socket =
      socket
      |> assign(
        group_id: id,
        summary: summary
      )

    {:ok, socket}
  end

  defp summary_section(assigns) do
    ~H"""
    <div id={@id}>
      <.header>Summary</.header>
      <ul>
        <li :for={{name, amount} <- elem(@summary, 1)} class="list-disc" id={"balance-#{name}"}>
          <b><%= elem(@summary, 0) %></b>
          owes <b><%= name %></b> <span class="ml-2"><%= to_currency(amount) %></span>
        </li>
      </ul>
    </div>
    """
  end

  defp to_currency(amount) do
    sign = maybe_minus_sign(amount)

    amount
    |> abs()
    |> Integer.to_charlist()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.join(",")
    |> String.reverse()
    |> (&"#{sign}$#{&1}").()
  end

  defp maybe_minus_sign(amount) when amount < 0, do: "-"
  defp maybe_minus_sign(_), do: nil

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
