defmodule Splitmore.AccountsTest do
  use Splitmore.DataCase

  alias Splitmore.Accounts

  alias Splitmore.Accounts.User

  import Splitmore.UsersFixtures

  @invalid_attrs %{name: nil, amount: nil}

  describe "list_users/1" do
    test "returns users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end
  end

  describe "get_user_by_email/1" do
    test "returns a user" do
      user = user_fixture()
      assert Accounts.get_user_by_email(user.email) == user
    end

    test "returns nil" do
      assert Accounts.get_user_by_email("") == nil
    end
  end

  describe "get_user!/1" do
    test "returns a user" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "throws Ecto.NoResultsError" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!("930ec9de-fac5-4d21-88da-ee41ea5f1615")
      end
    end
  end

  describe "get_user/1" do
    test "returns a user" do
      user = user_fixture()
      assert Accounts.get_user(user.id) == user
    end

    test "returns nil" do
      assert Accounts.get_user(nil) == nil
    end
  end

  describe "create_user/1" do
    test "returns {:ok, %User{}}" do
      valid_attrs = %{
        email: "test@example.com",
        token: "ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK",
        provider: "github"
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "test@example.com"
      assert user.token == "ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK"
      assert user.provider == "github"
    end

    test "returns {:error, %Ecto.Changeset{}}" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end
end
