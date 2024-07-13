defmodule Cklist.Repo.Migrations.AddAccessProperty do
  use Ecto.Migration

  def change do
    alter table("checklists") do
      add :access, :string
    end
  end
end
