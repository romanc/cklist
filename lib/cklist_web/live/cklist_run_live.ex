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

      |> assign(:current_step, Enum.at(checklist.document["steps"], 0))
      |> assign(:next_step, Enum.at(checklist.document["steps"], 1))
    {:ok, socket}
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

  def handle_event("completed", _params, socket) do
    { :noreply, assign(socket, :completed, true) }
  end

  def handle_event("abort", _params, %{assigns: assigns} = socket) do
    {
      :noreply,
      socket
        |> put_flash(:info, "Aborting checklist run")
        |> redirect(to: ~p"/checklists/#{assigns.checklist}")
    }
  end

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
        updated_steps_done = assigns.steps_done + 1
        completed = assigns.steps === updated_steps_done
        {
        :noreply,
        socket
          |> assign(:steps_done, updated_steps_done)
          |> assign(:current_step, Enum.at(assigns.checklist.document["steps"], updated_steps_done))
          |> assign(:next_step, Enum.at(assigns.checklist.document["steps"], updated_steps_done + 1))
          |> assign(:completed, completed)
        }
    end
  end

  defp is_done({_, true}, count), do: count + 1
  defp is_done(_, count), do: count
end
