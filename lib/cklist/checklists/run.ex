defmodule Cklist.Checklists.Run do
  use Ecto.Schema

  schema "runs" do
    belongs_to :checklist, Cklist.Checklists.Checklist
    has_many :activities, Cklist.Checklists.Activity
  end
end
