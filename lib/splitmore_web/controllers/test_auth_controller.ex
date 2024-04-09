defmodule SplitmoreWeb.TestAuthController do
  @moduledoc """
  For test purposes only.
  """
  use SplitmoreWeb, :controller

  plug Ueberauth

  alias Splitmore.Accounts.User
  alias Splitmore.Repo

  def login(conn, %{"email" => email} = _params) do
    user = Repo.get_by(User, email: email)

    conn
    |> put_session(:user_id, user.id)
    |> redirect(to: ~p"/")
  end
end
