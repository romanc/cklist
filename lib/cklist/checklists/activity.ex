defmodule Cklist.Checklists.Activity do
  use Ecto.Schema

  schema "activities" do
    field :event, :string
    field :payload, :map

    belongs_to :run, Cklist.Checklists.Run
    belongs_to :user, Cklist.Accounts.User

    # We don't expect activities to be modified.
    timestamps([type: :utc_datetime, updated_at: false])
  end
end
