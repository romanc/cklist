defmodule Cklist.Repo.Migrations.CreateChecklistRun do
  use Ecto.Migration

  def change do
    create table(:runs) do
      add :checklist_id, references(:checklists)
    end
  end
end
