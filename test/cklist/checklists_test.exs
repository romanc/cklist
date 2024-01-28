defmodule Cklist.ChecklistsTest do
  use Cklist.DataCase

  alias Cklist.Checklists

  describe "checklists" do
    alias Cklist.Checklists.Checklist

    import Cklist.ChecklistsFixtures

    @invalid_attrs %{description: nil, title: nil, document: nil}

    test "list_checklists/0 returns all checklists" do
      checklist = checklist_fixture()
      assert Checklists.list_checklists() == [checklist]
    end

    test "get_checklist!/1 returns the checklist with given id" do
      checklist = checklist_fixture()
      assert Checklists.get_checklist!(checklist.id) == checklist
    end

    test "create_checklist/1 with valid data creates a checklist" do
      valid_attrs = %{description: "some description", title: "some title", document: %{}}

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
