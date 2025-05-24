defmodule Cklist.Repo.Migrations.CreateActivityLog do
  use Ecto.Migration

  def change do
    create table(:activity) do
      add :event, :map

      add :user_id, references(:users, on_delete: :delete_all)
      add :run_id, references(:runs, on_delete: :delete_all)

      timestamps([type: :utc_datetime, updated_at: false])
    end
  end
end
