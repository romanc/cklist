defmodule Cklist.Checklists.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activity" do
    # We assume events have a type. Any other properties are optional and type-dependent.
    field :event, :map

    belongs_to :run, Cklist.Checklists.Run
    belongs_to :user, Cklist.Accounts.User

    # We don't expect activities to be modified.
    timestamps([type: :utc_datetime, updated_at: false])
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:event, :run_id, :user_id])
    |> validate_required([:event, :run_id, :user_id])
  end
end
