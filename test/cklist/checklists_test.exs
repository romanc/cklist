defmodule Cklist.ChecklistsTest do
  use Cklist.DataCase

  alias Cklist.Checklists

  describe "checklists" do
    alias Cklist.Checklists.Checklist

    import Cklist.ChecklistsFixtures
    import Cklist.AccountsFixtures

    @invalid_attrs %{description: nil, title: nil, document: nil}

    test "list_checklists/1 returns all checklists except private ones of other users" do
      id = user_fixture().id
      checklists = multiple_checklist_fixture(%{id1: id, id2: user_fixture().id})
      assert Checklists.list_checklists(%{id: id}) == checklists
    end

    test "get_checklist!/1 returns the checklist with given id" do
      checklist = checklist_fixture()
      assert Checklists.get_checklist!(checklist.id) == checklist
    end

    test "create_checklist/1 with valid data creates a checklist" do
      valid_attrs = %{description: "some description", title: "some title", user_id: 1, access: "personal", document: %{}}

      assert {:ok, %Checklist{} = checklist} = Checklists.create_checklist(valid_attrs)
      assert checklist.description == "some description"
      assert checklist.title == "some title"
      assert checklist.document == %{}
    end

    test "create_checklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Checklists.create_checklist(@invalid_attrs)
    end

    test "update_checklist/2 with valid data updates the checklist" do
      checklist = checklist_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", document: %{}}

      assert {:ok, %Checklist{} = checklist} = Checklists.update_checklist(checklist, update_attrs)
      assert checklist.description == "some updated description"
      assert checklist.title == "some updated title"
      assert checklist.document == %{}
    end

    test "update_checklist/2 with invalid data returns error changeset" do
      checklist = checklist_fixture()
      assert {:error, %Ecto.Changeset{}} = Checklists.update_checklist(checklist, @invalid_attrs)
      assert checklist == Checklists.get_checklist!(checklist.id)
    end

    test "delete_checklist/1 deletes the checklist" do
      checklist = checklist_fixture()
      assert {:ok, %Checklist{}} = Checklists.delete_checklist(checklist)
      assert_raise Ecto.NoResultsError, fn -> Checklists.get_checklist!(checklist.id) end
    end

    test "change_checklist/1 returns a checklist changeset" do
      checklist = checklist_fixture()
      assert %Ecto.Changeset{} = Checklists.change_checklist(checklist)
    end
  end
end
