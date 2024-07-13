defmodule Cklist.Repo.Migrations.CreateChecklists do
  use Ecto.Migration

  def change do
    create table(:checklists) do
      add :title, :string
      add :description, :string
      add :document, :map
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:checklists, [:user_id])
  end
end
