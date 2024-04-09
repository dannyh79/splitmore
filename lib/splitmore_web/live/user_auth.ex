defmodule SplitmoreWeb.UserAuth do
  @moduledoc """
  Sets up current_user in a live session
  """
  import Phoenix.Component
  alias Splitmore.Accounts
  import Phoenix.LiveView

  def on_mount(:default, _params, session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        session
        |> Map.get("user_id")
        |> Accounts.get_user()
      end)

    if socket.assigns.current_user != nil do
      {:cont, socket}
    else
      {:halt, socket |> put_flash(:error, "Please log in first.") |> redirect(to: "/")}
    end
  end
end
