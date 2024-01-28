defmodule Cklist.Checklists.Checklist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checklists" do
    field :description, :string
    field :title, :string
    field :document, :map
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(checklist, attrs) do
    checklist
    |> cast(attrs, [:title, :description, :document])
    |> validate_required([:title, :description])
  end
end
