defmodule CklistWeb.CklistRunLive do
  use CklistWeb, :live_view

  alias Cklist.Checklists

  def render(assigns) do
    case assigns.checklist.document do
      %{"version" => "0.1", "sequential" => true} -> render_sequential(assigns)
      %{"version" => "0.1", "sequential" => false} -> render_unordered(assigns)
    end
  end

  def render_sequential(assigns) do
    ~H"""
    <.header>
      Checklist <%= @checklist.id %>
      <:subtitle>This renders a sequential checklist.</:subtitle>
    </.header>
    """
  end

  def render_unordered(assigns) do
    ~H"""
    <.header>
      <%= @checklist.title %>
      <:subtitle><%= @checklist.description %></:subtitle>
    </.header>

    <p>&nbsp;</p>
    <.progress steps={@steps} done={@done} />

    <form>
    <%= for step <- @checklist.document["steps"] do %>
      <.input type="checkbox" label={step["name"]} name={step["name"]} phx-change="step_done" />
    <% end %>
    </form>

    <.back navigate={~p"/checklists/#{@checklist}"}>Back to checklist</.back>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    checklist = Checklists.get_checklist!(id)
    socket = socket
      |> assign(:checklist, checklist)
      |> assign(:steps, length(checklist.document["steps"]))
      |> assign(:done, 0)
    {:ok, socket}
  end

  def handle_event("step_done", _params, socket) do
    {:noreply, update(socket, :done, &(&1 + 1))}
  end
end
