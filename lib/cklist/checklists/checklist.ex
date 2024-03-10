defmodule Cklist.Checklists.Checklist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checklists" do
    field :description, :string
    field :title, :string
    field :document, :map
    field :access, Ecto.Enum, values: [:public, :personal]

    belongs_to :user, Cklist.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(checklist, attrs) do
    checklist
    |> cast(attrs, [:title, :description, :document, :user_id, :access])
    |> validate_required([:title, :description, :document, :user_id, :access])
  end
end
