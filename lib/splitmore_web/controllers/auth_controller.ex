defmodule SplitmoreWeb.AuthController do
  use SplitmoreWeb, :controller

  plug Ueberauth

  alias Splitmore.Accounts

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_data = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}

    case find_or_create_user(user_data) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.email}, welcome!")
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: "/")
    end
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/")
  end

  defp find_or_create_user(user_data) do
    case Accounts.get_user_by_email(user_data.email) do
      nil ->
        IO.puts("User #{user_data.email} not found, creating new one")
        Accounts.create_user(user_data)

      user ->
        {:ok, user}
    end
  end
end
