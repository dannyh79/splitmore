defmodule SplitmoreWeb.ExpenseLive.FormComponent do
  use SplitmoreWeb, :live_component

  alias Splitmore.Accounts
  alias Splitmore.Expenses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage expense records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="expense-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:amount]} type="number" label="Amount" />
        <.input
          field={@form[:paid_by_id]}
          type="select"
          label="Paid by"
          options={@users}
          value={@current_user.id}
        />
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <.input field={@form[:group_id]} type="hidden" value={@group_id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Expense</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    paid_by_options =
      Accounts.list_users()
      |> Enum.map(fn u -> {u.email, u.id} end)
      |> Enum.sort_by(fn {email, _} -> email end)

    {:ok, assign(socket, :users, paid_by_options)}
  end

  @impl true
  def update(%{expense: expense} = assigns, socket) do
    changeset = Expenses.change_expense(expense)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    changeset =
      socket.assigns.expense
      |> Expenses.change_expense(expense_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"expense" => expense_params}, socket) do
    save_expense(socket, socket.assigns.action, expense_params)
  end

  defp save_expense(socket, :edit, expense_params) do
    case Expenses.update_expense(socket.assigns.expense, expense_params) do
      {:ok, expense} ->
        notify_parent({:saved, expense})

        {:noreply,
         socket
         |> put_flash(:info, "Expense updated successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_expense(socket, :new, expense_params) do
    case Expenses.create_expense(expense_params) do
      {:ok, expense} ->
        notify_parent({:saved, expense})

        {:noreply,
         socket
         |> put_flash(:info, "Expense created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
