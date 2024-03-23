defmodule CklistWeb.CklistNewLive do
  use CklistWeb, :live_view

  alias Cklist.Checklists
  alias Cklist.Checklists.Checklist

  def render(assigns) do
    CklistWeb.ChecklistHTML.new(assigns)
  end

  def mount(_params, _session, socket) do
    changeset = Checklists.change_checklist(%Checklist{})
    socket = socket
      |> assign(:changeset, changeset)
    {:ok, socket}
  end
end
