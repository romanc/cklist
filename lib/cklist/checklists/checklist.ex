defmodule Cklist.Checklists.Checklist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checklists" do
    field :title, :string
    field :description, :string
    field :access, Ecto.Enum, values: [:public, :personal]
    field :document, :map

    timestamps(type: :utc_datetime)

    belongs_to :user, Cklist.Accounts.User
    has_many :runs, Cklist.Checklists.Run, on_delete: :delete_all
  end

  @doc false
  def changeset(checklist, attrs) do
    checklist
    |> cast(attrs, [:title, :description, :access, :document, :user_id])
    |> validate_required([:title, :description, :access, :document, :user_id])
  end
end
