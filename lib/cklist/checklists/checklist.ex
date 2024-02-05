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
    |> cast(attrs, [:title, :description, :document, :user_id])
    |> validate_required([:title, :description, :user_id])
  end
end
