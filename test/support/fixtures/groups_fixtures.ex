defmodule Splitmore.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Splitmore.Groups` context.
  """

  alias Splitmore.Groups.GroupUser

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Splitmore.Groups.create_group()

    group
  end

  @doc """
  Generate a group user association.
  """
  def group_user_fixture(%{group_id: _, user_id: _} = attrs) do
    {:ok, group_user} =
      %GroupUser{}
      |> GroupUser.changeset(attrs)
      |> Splitmore.Repo.insert()

    group_user
    |> Splitmore.Repo.preload(:user)
  end
end
