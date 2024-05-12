defmodule CklistWeb.CklistRunLive do
  use CklistWeb, :live_view

  alias Cklist.Checklists

  def render(assigns) do
    CklistWeb.ChecklistHTML.run(assigns)
  end

  def mount(%{"id" => id}, _session, socket) do
    user = socket.assigns.current_user

    checklist = Checklists.get_checklist!(id)
    run = Checklists.log_run_start(checklist, user)

    socket = socket
      |> assign(:checklist, checklist)
      |> assign(:run, run)
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
    Checklists.log_run_abort(assigns.run, assigns.current_user)
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
        {
        :noreply,
        socket
          |> put_flash(:info, "Well done!")
          |> redirect(to: ~p"/checklists/#{assigns.checklist}")
        }
      false ->
        Checklists.log_step_complete(assigns.run, assigns.current_user, assigns.steps_done)
        updated_steps_done = assigns.steps_done + 1
        completed = assigns.steps === updated_steps_done
        if completed do
          Checklists.log_run_complete(assigns.run, assigns.current_user)
        end
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
    is_done = Map.get(params, step_name) == "true"
    updated_state = Map.put(assigns.step_state, step_name, is_done)
    updated_steps_done = Enum.reduce(updated_state,  0, &is_done/2)

    step_id = Enum.find_index(assigns.checklist.document["steps"], &(&1["name"] == step_name))
    Checklists.log_step_complete(assigns.run, assigns.current_user, step_id, is_done)

    completed = updated_steps_done === assigns.steps
    if completed do
      Checklists.log_run_complete(assigns.run, assigns.current_user)
    end

    {
      :noreply,
      socket
      |> assign(:step_state, updated_state)
      |> assign(:steps_done, updated_steps_done)
      |> assign(:completed, completed)
    }
  end

  defp is_done({_, true}, count), do: count + 1
  defp is_done(_, count), do: count
end
