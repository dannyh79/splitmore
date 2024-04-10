defmodule SplitmoreWeb.GroupLive.Show do
  use SplitmoreWeb, :live_view

  alias Splitmore.Groups

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    group = Groups.get_group!(id)

    {:noreply,
     socket
     |> assign(:group, group)
     |> assign(:page_title, page_title(socket.assigns, group))}
  end

  defp page_title(%{live_action: :show}, %{name: name}), do: "Show #{name} Expenses"
  defp page_title(%{live_action: :edit}, _), do: "Edit Group"
end
