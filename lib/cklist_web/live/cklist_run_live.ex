defmodule CklistWeb.CklistRunLive do
  use CklistWeb, :live_view

  alias Cklist.Checklists

  def render(assigns) do
    CklistWeb.ChecklistHTML.run(assigns)
  end

  def mount(%{"id" => id}, _session, socket) do
    checklist = Checklists.get_checklist!(id)
    socket = socket
      |> assign(:checklist, checklist)
      |> assign(:steps, length(checklist.document["steps"]))
      |> assign(:steps_done, 0)
      |> assign(:completed, false)
      |> assign(:step_state, %{})
    {:ok, socket}
  end

  def handle_event("completed", _params, socket) do
    { :noreply, assign(socket, :completed, true) }
  end

  def handle_event("step_done", params, %{assigns: assigns} = socket) do
    [step_name] = params["_target"]
    updated_state = Map.put(assigns.step_state, step_name, Map.get(params, step_name) == "true")

    {
      :noreply,
      socket
      |> assign(:step_state, updated_state)
      |> assign(:steps_done, Enum.reduce(updated_state,  0, &is_done/2))
    }
  end

  defp is_done({_, true}, count), do: count + 1
  defp is_done(_, count), do: count
end
