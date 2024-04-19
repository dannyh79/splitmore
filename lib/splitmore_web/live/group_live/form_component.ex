defmodule SplitmoreWeb.GroupLive.FormComponent do
  use SplitmoreWeb, :live_component

  alias Splitmore.Groups

  @impl true
  def render(assigns) do
    assigns =
      assign(assigns,
        group: %{
          assigns.group
          | users: [
              {
                "930ec9de-fac5-4d21-88da-ee41ea5f1615",
                %{admin?: true, email: "chenghsuan.han@gmail.com"}
              },
              {
                "2fd1e6d3-1dea-46ea-8e52-64d367198969",
                %{admin?: false, email: "another@example.com"}
              }
            ]
        }
      )

    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage group records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="group-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.table id="group_users" rows={@group.users}>
          <:col :let={{id, user}} label="Admin">
            <.input type="checkbox" name={id} checked={user.admin?} />
          </:col>
          <:col :let={{_id, user}} label="Email"><%= user.email %></:col>
        </.table>
        <:actions>
          <.button phx-disable-with="Saving...">Save Group</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{group: group} = assigns, socket) do
    changeset = Groups.change_group(group)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"group" => group_params}, socket) do
    changeset =
      socket.assigns.group
      |> Groups.change_group(group_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"group" => group_params}, socket) do
    save_group(socket, socket.assigns.action, group_params)
  end

  defp save_group(socket, :edit, group_params) do
    case Groups.update_group(socket.assigns.group, group_params) do
      {:ok, group} ->
        notify_parent({:saved, group})

        {:noreply,
         socket
         |> put_flash(:info, "Group updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_group(socket, :new, group_params) do
    case Groups.create_group(group_params) do
      {:ok, group} ->
        # TODO: wrap Groups.create_group/1 and Groups.add_user_to_group/2 in Ecto.Multi
        Groups.add_user_to_group(group, socket.assigns.current_user)
        notify_parent({:saved, group})

        {:noreply,
         socket
         |> put_flash(:info, "Group created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
