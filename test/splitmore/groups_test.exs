defmodule Splitmore.GroupsTest do
  use Splitmore.DataCase

  alias Splitmore.Groups
  alias Splitmore.Groups.Group

  import Splitmore.GroupsFixtures
  import Splitmore.TestUtils, only: [drop: 2]
  import Splitmore.UsersFixtures

  @invalid_attrs %{name: nil}

  describe "list_groups/0" do
    test "returns all groups" do
      group = group_fixture()
      assert Groups.list_groups() == [group]
    end
  end

  describe "get_group!/1" do
    test "returns the group with given id" do
      group = group_fixture()
      assert Groups.get_group!(group.id) == group
    end
  end

  describe "get_group_with_users!/1" do
    test "returns the group with its associated users" do
      group = group_fixture()
      users = for _ <- 1..2, do: user_fixture()

      group_users =
        users
        |> Enum.map(&group_user_fixture(%{group_id: group.id, user_id: &1.id}))

      result = Groups.get_group_with_users!(group.id)
      assert drop(result, [:users]) == drop(group, [:users])
      assert result.users == group_users
    end
  end

  describe "create_group/1" do
    test "creates a group" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Group{} = group} = Groups.create_group(valid_attrs)
      assert group.name == "some name"
    end

    test "returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_group(@invalid_attrs)
    end
  end

  describe "update_group/2" do
    test "updates the group" do
      group = group_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Group{} = group} = Groups.update_group(group, update_attrs)
      assert group.name == "some updated name"
    end

    test "returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update_group(group, @invalid_attrs)
      assert group == Groups.get_group!(group.id)
    end
  end

  describe "delete_group/1" do
    test "deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Groups.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_group!(group.id) end
    end
  end

  describe "change_group/1" do
    test "returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Groups.change_group(group)
    end
  end

  describe "maybe_add_users_to_group/1" do
    test "returns {:ok}" do
      group = group_fixture()
      user = user_fixture()
      paid_by = user_fixture()

      assert {:ok} =
               Groups.maybe_add_users_to_group(%{
                 "group_id" => group.id,
                 "user_id" => user.id,
                 "paid_by_id" => paid_by.id
               })
    end

    test "returns {:ok} when users are already in the group" do
      group = group_fixture()
      user = user_fixture()
      paid_by = user_fixture()

      Splitmore.Repo.query!("INSERT INTO groups_users (group_id, user_id) VALUES
        ('#{group.id}', '#{user.id}'),
        ('#{group.id}', '#{paid_by.id}')")

      assert {:ok} =
               Groups.maybe_add_users_to_group(%{
                 "group_id" => group.id,
                 "user_id" => user.id,
                 "paid_by_id" => paid_by.id
               })
    end
  end

  describe "add_user_to_group/2" do
    test "returns {:ok, %Group{}}" do
      group = group_fixture()
      user = user_fixture()

      assert {:ok, %Group{}} = Groups.add_user_to_group(group, user)
    end
  end

  describe "group_admin?/1" do
    test "returns true" do
      assert Groups.group_admin?(:admin)
    end

    test "returns false" do
      refute Groups.group_admin?(:foo)
    end
  end
end
