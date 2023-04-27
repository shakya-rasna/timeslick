defmodule DttRecharger.FailuresTest do
  use DttRecharger.DataCase

  alias DttRecharger.Failures

  describe "failures" do
    alias DttRecharger.Failures.Failure

    import DttRecharger.FailuresFixtures

    @invalid_attrs %{error_message: nil, status: nil}

    test "list_failures/0 returns all failures" do
      failure = failure_fixture()
      assert Failures.list_failures() == [failure]
    end

    test "get_failure!/1 returns the failure with given id" do
      failure = failure_fixture()
      assert Failures.get_failure!(failure.id) == failure
    end

    test "create_failure/1 with valid data creates a failure" do
      valid_attrs = %{error_message: "some error_message", status: "some status"}

      assert {:ok, %Failure{} = failure} = Failures.create_failure(valid_attrs)
      assert failure.error_message == "some error_message"
      assert failure.status == "some status"
    end

    test "create_failure/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Failures.create_failure(@invalid_attrs)
    end

    test "update_failure/2 with valid data updates the failure" do
      failure = failure_fixture()
      update_attrs = %{error_message: "some updated error_message", status: "some updated status"}

      assert {:ok, %Failure{} = failure} = Failures.update_failure(failure, update_attrs)
      assert failure.error_message == "some updated error_message"
      assert failure.status == "some updated status"
    end

    test "update_failure/2 with invalid data returns error changeset" do
      failure = failure_fixture()
      assert {:error, %Ecto.Changeset{}} = Failures.update_failure(failure, @invalid_attrs)
      assert failure == Failures.get_failure!(failure.id)
    end

    test "delete_failure/1 deletes the failure" do
      failure = failure_fixture()
      assert {:ok, %Failure{}} = Failures.delete_failure(failure)
      assert_raise Ecto.NoResultsError, fn -> Failures.get_failure!(failure.id) end
    end

    test "change_failure/1 returns a failure changeset" do
      failure = failure_fixture()
      assert %Ecto.Changeset{} = Failures.change_failure(failure)
    end
  end
end
