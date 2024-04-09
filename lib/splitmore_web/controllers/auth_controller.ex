defmodule SplitmoreWeb.AuthController do
  use SplitmoreWeb, :controller

  plug Ueberauth

  alias Splitmore.Accounts.User
  alias Splitmore.Repo

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
    changeset = User.changeset(%User{}, user_data)

    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        IO.puts("User #{changeset.changes.email} not found, creating new one")
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end
end
