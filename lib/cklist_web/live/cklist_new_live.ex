defmodule CklistWeb.CklistNewLive do
  use CklistWeb, :live_view

  alias Cklist.Checklists
  alias Cklist.Checklists.Checklist

  def render(assigns) do
    CklistWeb.ChecklistHTML.new(assigns)
  end

  def mount(_params, _session, socket) do
    changeset = Checklists.change_checklist(
      %Checklist{
        access: :personal,
        document: %{
          version: "0.1",
          sequential: true,
          steps: [
            %{ name: "Step one", description: "Lorem ipsum" },
            %{ name: "Step two", description: "dolor sit amet" }
          ]
        },
        user_id: socket.assigns.current_user.id,
      }
    )

    socket = socket
      |> assign(:changeset, changeset)
    {:ok, socket}
  end

  def handle_event("form_changed", params, socket) do
    new_checklist = checklist_from(params, socket)

    changeset = Checklists.change_checklist(
      socket.assigns.changeset.data,
      Map.merge(
        socket.assigns.changeset.changes,
        Map.put(new_checklist, :document, document_from(params, socket))
      )
    )

    socket = socket
      |> assign(:changeset, changeset)

    { :noreply, socket }
  end

  def handle_event("step_add", _params, socket) do
    document = latest_document(socket)

    changeset = Checklists.change_checklist(
      socket.assigns.changeset.data,
      Map.merge(
        socket.assigns.changeset.changes,
        %{ document: %{
          sequential: document.sequential,
          steps: document.steps ++ [%{name: "New step", description: "with description"}],
          version: document.version,
        }}
      )
    )

    socket = socket
      |> assign(:changeset, changeset)

    { :noreply, socket }
  end

  def handle_event("step_remove", _params, socket) do
    document = latest_document(socket)

    changeset = Checklists.change_checklist(
      socket.assigns.changeset.data,
      Map.merge(
        socket.assigns.changeset.changes,
        %{ document: %{
          sequential: document.sequential,
          steps: List.delete_at(document.steps, length(document.steps) - 1),
          version: document.version,
        }}
      )
    )

    socket = socket
        |> assign(:changeset, changeset)

    { :noreply, socket }
  end

  def handle_event("save_checklist", _params, socket) do
    changeset = socket.assigns.changeset

    case changeset.valid? && Checklists.insert_checklist(changeset) do
      {:ok, checklist} ->
        {:noreply, socket
        |> put_flash(:info, "Checklist created successfully.")
        |> redirect(to: ~p"/checklists/#{checklist}")}

      false ->
        {:noreply, socket
        |> put_flash(:error, "Checklist creation failed.")
        |> assign(:changeset, changeset)}
    end
  end

  defp checklist_from(params, _socket) do
    %{
      title: params["checklist"]["title"],
      description: params["checklist"]["description"],
      access: (if params["checklist"]["access"] === "personal", do: :personal, else: :public)
    }
  end

  defp document_from(params, socket) do
    document = latest_document(socket)
    steps = Map.filter(params, fn {key, _val} -> String.starts_with?(key, "step-") end)
    descriptions = Map.filter(params, fn {key, _val} -> String.starts_with?(key, "desc-") end)
      |> Enum.map(fn {key, val} -> {String.replace(key, "desc", "step"), val} end )
      |> Map.new()
    steps = Map.merge(steps, descriptions, fn _key, name, desc -> %{name: name, description: desc} end)
      |> Map.values()

    %{
      sequential: (if Map.get(params, "sequential", document.sequential) == "true", do: true, else: false),
      steps: steps,
      version: document.version,
    }
  end

  defp latest_document(socket) do
    Map.get(socket.assigns.changeset.changes, :document, socket.assigns.changeset.data.document)
  end
end
