defmodule CklistWeb.CklistRunLive do
  use CklistWeb, :live_view

  alias Cklist.Checklists

  def render(assigns) do
    CklistWeb.ChecklistHTML.run(assigns)
  end

  def mount(%{"id" => id}, _session, socket) do
    checklist = Checklists.get_checklist!(id)

    # Log: cklist started

    socket = socket
      |> assign(:checklist, checklist)
      |> assign(:steps, length(checklist.document["steps"]))
      |> assign(:steps_done, 0)
      |> assign(:completed, false)
      |> assign(:step_state, %{})

      |> assign(:current_step, Enum.at(checklist.document["steps"], 0))
      |> assign(:next_step, Enum.at(checklist.document["steps"], 1))
    {:ok, socket}
  end

  # Handles aborting a checklist.
  def handle_event("abort", _params, %{assigns: assigns} = socket) do
    # Log: cklist aborted

    {
      :noreply,
      socket
        |> put_flash(:info, "Aborting checklist run")
        |> redirect(to: ~p"/checklists/#{assigns.checklist}")
    }
  end

  # Handles "next_step" event for sequential checklists.
  def handle_event("next_step", _params, %{assigns: assigns} = socket) do
    case assigns.completed do
      true ->
        # Log: cklist completed
        {
        :noreply,
        socket
          |> put_flash(:info, "Well done!")
          |> redirect(to: ~p"/checklists/#{assigns.checklist}")
        }
      false ->
        # Log: cklist step completed
        updated_steps_done = assigns.steps_done + 1
        completed = assigns.steps === updated_steps_done
        {
        :noreply,
        socket
          |> assign(:current_step, Enum.at(assigns.checklist.document["steps"], updated_steps_done))
          |> assign(:next_step, Enum.at(assigns.checklist.document["steps"], updated_steps_done + 1))
          |> assign(:steps_done, updated_steps_done)
          |> assign(:completed, completed)
        }
    end
  end

  # Handles "step_done" events for non-sequential checklists.
  def handle_event("step_done", params, %{assigns: assigns} = socket) do
    [step_name] = params["_target"]
    updated_state = Map.put(assigns.step_state, step_name, Map.get(params, step_name) == "true")
    updated_steps_done = Enum.reduce(updated_state,  0, &is_done/2)

    # Log cklist step completed

    {
      :noreply,
      socket
      |> assign(:step_state, updated_state)
      |> assign(:steps_done, updated_steps_done)
      |> assign(:completed, updated_steps_done === assigns.steps)
    }
  end

  defp is_done({_, true}, count), do: count + 1
  defp is_done(_, count), do: count
end
