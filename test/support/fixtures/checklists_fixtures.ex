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
        title: "some title"
      })
      |> Cklist.Checklists.create_checklist()

    checklist
  end
end
