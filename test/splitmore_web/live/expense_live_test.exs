defmodule SplitmoreWeb.ExpenseLiveTest do
  use SplitmoreWeb.ConnCase

  import Phoenix.LiveViewTest
  import Splitmore.ExpensesFixtures

  @create_attrs %{name: "some name", amount: 42}
  @update_attrs %{name: "some updated name", amount: 43}
  @invalid_attrs %{name: nil, amount: nil}

  defp create_expense(%{user: user}) do
    expense = expense_fixture(%{user_id: user.id})
    %{expense: expense}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_expense]

    test "lists all expenses", %{conn: conn, expense: expense} do
      {:ok, _index_live, html} = live(conn, ~p"/expenses")

      assert html =~ "Listing Expenses"
      assert html =~ expense.name
    end

    test "saves new expense", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/expenses")

      assert index_live |> element("a", "New Expense") |> render_click() =~
               "New Expense"

      assert_patch(index_live, ~p"/expenses/new")

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#expense-form", expense: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/expenses")

      html = render(index_live)
      assert html =~ "Expense created successfully"
      assert html =~ "some name"
    end

    test "updates expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, ~p"/expenses")

      assert index_live |> element("#expenses-#{expense.id} a", "Edit") |> render_click() =~
               "Edit Expense"

      assert_patch(index_live, ~p"/expenses/#{expense}/edit")

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#expense-form", expense: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/expenses")

      html = render(index_live)
      assert html =~ "Expense updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, ~p"/expenses")

      assert index_live |> element("#expenses-#{expense.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#expenses-#{expense.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_expense]

    test "displays expense", %{conn: conn, expense: expense} do
      {:ok, _show_live, html} = live(conn, ~p"/expenses/#{expense}")

      assert html =~ "Show Expense"
      assert html =~ expense.name
    end

    test "updates expense within modal", %{conn: conn, expense: expense} do
      {:ok, show_live, _html} = live(conn, ~p"/expenses/#{expense}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Expense"

      assert_patch(show_live, ~p"/expenses/#{expense}/show/edit")

      assert show_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#expense-form", expense: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/expenses/#{expense}")

      html = render(show_live)
      assert html =~ "Expense updated successfully"
      assert html =~ "some updated name"
    end
  end
end
