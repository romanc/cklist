defmodule Cklist.ChecklistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cklist.Checklists` context.
  """

  @doc """
  Generate a checklist.
  """
  def checklist_fixture(attrs \\ %{}) do
    {:ok, checklist} =
      attrs
      |> Enum.into(%{
        description: "some description",
        document: %{},
        title: "some title",
        access: "personal",
        user_id: 1
      })
      |> Cklist.Checklists.create_checklist()

    checklist
  end

  @doc """
  Generates multiple checklists of different users.
  """
  def multiple_checklist_fixture(users) do
    attrs = %{}
    {:ok, checklist1} =
      attrs
      |> Enum.into(%{
        description: "some description",
        document: %{},
        title: "some title",
        access: "personal",
        user_id: users.id1
      })
      |> Cklist.Checklists.create_checklist()

    {:ok, checklist2} =
      attrs
      |> Enum.into(%{
        description: "some description",
        document: %{},
        title: "some other title",
        access: "public",
        user_id: users.id2
      })
      |> Cklist.Checklists.create_checklist()

    [checklist1, checklist2]
  end
end
