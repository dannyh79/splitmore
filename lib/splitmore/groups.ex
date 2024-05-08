defmodule Splitmore.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  alias Splitmore.Accounts.User
  alias Splitmore.Groups.Group
  alias Splitmore.Groups.GroupUser
  alias Splitmore.Repo

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  def get_group_with_users!(id) do
    Group
    |> Repo.get!(id)
    |> Repo.preload(users: [:user])
  end

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{data: %Group{}}

  """
  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end

  def maybe_add_users_to_group(
        %{"group_id" => group_id, "user_id" => user_id, "paid_by_id" => paid_by_id} =
          _expense_params
      ) do
    group =
      Group
      |> Repo.get!(group_id)
      |> Repo.preload(:users)

    user = Repo.get!(User, user_id)
    paid_by = Repo.get!(User, paid_by_id)
    maybe_add_user_to_group(group, user)
    maybe_add_user_to_group(group, paid_by)
  end

  defp maybe_add_user_to_group(%Group{} = group, %User{} = user) do
    if user_in_group?(group, user) do
      {:ok}
    else
      p_add_user_to_group(group, user)
    end
  end

  defp user_in_group?(%Group{} = group, %User{} = user) do
    Enum.any?(group.users, &(&1.user_id == user.id))
  end

  defp p_add_user_to_group(%Group{} = group, %User{} = user) do
    group_user_changeset =
      %GroupUser{}
      |> GroupUser.changeset(%{group_id: group.id, user_id: user.id, role: :default})

    case Repo.insert(group_user_changeset) do
      {:ok, _group_user} -> {:ok}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def add_user_to_group(%Group{} = group, %User{} = user) do
    group_user_changeset =
      %GroupUser{}
      |> GroupUser.changeset(%{group_id: group.id, user_id: user.id, role: :default})

    case Repo.insert(group_user_changeset) do
      {:ok, _group_user} -> {:ok, group}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
