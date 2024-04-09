defmodule SplitmoreWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  alias Splitmore.Accounts.User
  alias Splitmore.Repo

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    user = user_id && Repo.get(User, user_id)

    if user != nil do
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end
end
