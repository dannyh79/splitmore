defmodule Splitmore.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Splitmore.Expenses` context.
  """
  alias Splitmore.Repo
  alias Splitmore.Accounts.User

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    params =
      Enum.into(attrs, %{
        email: "hello@example.com",
        provider: "github",
        token: Ecto.UUID.generate()
      })

    {:ok, user} =
      %User{}
      |> User.changeset(params)
      |> Repo.insert()

    user
  end
end
