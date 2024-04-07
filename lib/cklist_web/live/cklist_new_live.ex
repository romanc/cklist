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

  def handle_event("step_changed", _params, socket) do
    IO.inspect("Step changed")
    { :noreply, socket }
  end

  def handle_event("step_add", _params, socket) do
    IO.inspect("Adding new step")
    document = socket.assigns.changeset.changes.document

    {_, changeset} = Checklists.update_checklist(
      socket.assigns.changeset.data,
      %{ document: %{
        steps: document.steps ++ [%{name: "New step"}],
        sequential: document.sequential
      }}
    )

    socket = socket
        |> assign(:changeset, changeset)

    { :noreply, socket }
  end

  def handle_event("step_remove", _params, socket) do
    IO.inspect("Removing one step")

    document = socket.assigns.changeset.changes.document
    new_steps = List.delete_at(document.steps, length(document.steps)-1)

    {_, changeset} = Checklists.update_checklist(
      socket.assigns.changeset.data,
      %{ document: %{
        steps: new_steps,
        sequential: document.sequential
      }}
    )

    socket = socket
        |> assign(:changeset, changeset)

    { :noreply, socket }
  end

  def handle_event("save_checklist", params, socket) do
    IO.inspect("saving checklist")

    IO.inspect(params)
    checklist_params = params["checklist"]
    IO.inspect(checklist_params)
    steps = Map.filter(params, fn {key, _val} -> String.starts_with?(key, "step-") end)

    document = %{
      sequential: Map.get(params, "sequential", true),
      steps: Enum.map(Map.values(steps), fn val -> %{name: val} end)
    }

    checklist_params = checklist_params
    |> Map.put("user_id", socket.assigns.current_user.id)
    |> Map.put("document", document)

    IO.inspect(checklist_params)

    case Checklists.create_checklist(checklist_params) do
      {:ok, checklist} ->
        {:noreply, socket
        |> put_flash(:info, "Checklist created successfully.")
        |> redirect(to: ~p"/checklists/#{checklist}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket
        |> assign(:changeset, changeset)}
    end
  end
end
