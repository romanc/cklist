defmodule CklistWeb.CklistNewLive do
  use CklistWeb, :live_view

  alias Cklist.Checklists
  alias Cklist.Checklists.Checklist

  def render(assigns) do
    CklistWeb.ChecklistHTML.new(assigns)
  end

  def mount(_params, _session, socket) do
    changeset = Checklists.change_checklist(
      %Checklist{},
      %{ document: %{ sequential: true, steps: [%{name: "one"}, %{name: "two"}] } }
    )

    IO.inspect(changeset)

    socket = socket
      |> assign(:changeset, changeset)
    {:ok, socket}
  end

  # leave text field
  def handle_event("new_step", params, socket) do
    document = socket.assigns.changeset.changes.document

    IO.inspect(socket.assigns.changeset)

    {:ok, changeset} = Checklists.update_checklist(
      socket.assigns.changeset,
      %{ document: %{
        sequential: document.sequential,
        steps: [document.steps | %{name: params["new_step"]}]
      }}
    )

    socket = socket
      |> assign(:changeset, changeset)
    { :noreply, socket }
  end

  def handle_event("step_changed", params, socket) do
    IO.inspect(params)
    { :noreply, socket }
  end
end
