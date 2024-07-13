defmodule Cklist.Repo.Migrations.CreateChecklistRun do
  use Ecto.Migration

  def change do
    create table(:runs) do
      add :checklist_id, references(:checklists, on_delete: :delete_all)
    end
  end
end
