defmodule DttRecharger.UserOperationTest do
  use DttRecharger.DataCase

  alias DttRecharger.UserOperation

  describe "users" do
    alias DttRecharger.UserOperation.Schema.User

    import DttRecharger.UserOperationFixtures

    @invalid_attrs %{first_name: nil, last_name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserOperation.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserOperation.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{first_name: "some first_name", last_name: "some last_name"}

      assert {:ok, %User{} = user} = UserOperation.create_user(valid_attrs)
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserOperation.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{first_name: "some updated first_name", last_name: "some updated last_name"}

      assert {:ok, %User{} = user} = UserOperation.update_user(user, update_attrs)
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserOperation.update_user(user, @invalid_attrs)
      assert user == UserOperation.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserOperation.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserOperation.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserOperation.change_user(user)
    end
  end
end
