defmodule Splitmore.Expenses do
  @moduledoc """
  The Expenses context.
  """

  import Ecto, only: [assoc: 2]
  import Ecto.Query, warn: false
  alias Splitmore.Groups.Group
  alias Splitmore.Accounts.User
  alias Splitmore.BookKeeper
  alias Splitmore.Expenses.Expense
  alias Splitmore.Repo

  @doc """
  Returns the list of expenses.

  ## Examples

      iex> list_expenses()
      [%Expense{}, ...]

  """
  def list_expenses do
    Repo.all(Expense)
  end

  @doc """
  Returns the list of expenses of a group, with paid_by preloaded.

  ## Examples

      iex> list_group_expenses("2fd1e6d3-1dea-46ea-8e52-64d367198969")
      [%Expense{}, ...]

  """
  def list_group_expenses(group_id) do
    query =
      from e in Expense,
        where: e.group_id == ^group_id,
        preload: :paid_by

    Repo.all(query)
  end

  def summarize_group_balances(group_id, for) when is_struct(for, User) do
    expenses = p_list_group_expenses(group_id)
    group_users = p_list_group_users(group_id)

    BookKeeper.calculate_balances(expenses, group_users, for)
  end

  defp p_list_group_users(group_id) do
    group = Repo.get(Group, group_id)
    Repo.all(assoc(group, :users))
  end

  defp p_list_group_expenses(group_id) do
    query =
      from e in Expense,
        where: e.group_id == ^group_id,
        preload: :paid_by

    Repo.all(query)
  end

  @doc """
  Gets a single expense, with paid_by preloaded.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense!(123)
      %Expense{}

      iex> get_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense!(id), do: Repo.get!(Expense, id) |> Repo.preload(:paid_by)

  @doc """
  Creates a expense.

  ## Examples

      iex> create_expense(%{field: value})
      {:ok, %Expense{}}

      iex> create_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense(attrs \\ %{}) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a expense.

  ## Examples

      iex> update_expense(expense, %{field: new_value})
      {:ok, %Expense{}}

      iex> update_expense(expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a expense.

  ## Examples

      iex> delete_expense(expense)
      {:ok, %Expense{}}

      iex> delete_expense(expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense changes.

  ## Examples

      iex> change_expense(expense)
      %Ecto.Changeset{data: %Expense{}}

  """
  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end
end
