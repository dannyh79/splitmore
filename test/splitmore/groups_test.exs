defmodule Splitmore.GroupsTest do
  use Splitmore.DataCase

  alias Splitmore.Groups
  alias Splitmore.Groups.Group

  import Splitmore.GroupsFixtures

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
end
