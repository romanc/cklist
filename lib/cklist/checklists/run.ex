defmodule Cklist.Checklists.Run do
  use Ecto.Schema
  import Ecto.Changeset

  schema "runs" do
    belongs_to :checklist, Cklist.Checklists.Checklist
    has_many :activities, Cklist.Checklists.Activity, on_delete: :delete_all
  end

    @doc false
    def changeset(run, attrs) do
      run
      |> cast(attrs, [:checklist_id])
      |> validate_required([:checklist_id])
    end
end
