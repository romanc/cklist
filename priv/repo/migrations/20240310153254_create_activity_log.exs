defmodule Cklist.Repo.Migrations.CreateActivityLog do
  use Ecto.Migration

  def change do
    create table(:activity) do
      add :user_id, references(:users)
      add :run_id, references(:runs)

      add :event, :string
      add :payload, :map
    end
  end
end
