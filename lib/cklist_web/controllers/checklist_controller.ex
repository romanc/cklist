defmodule CklistWeb.ChecklistController do
  use CklistWeb, :controller

  alias Cklist.Checklists

  def index(conn, _params) do
    checklists = Checklists.list_checklists(conn.assigns.current_user)
    render(conn, :index, checklists: checklists)
  end

  def create(conn, params) do
    checklist_params = params["checklist"]
    steps = Map.filter(params, fn {key, _val} -> String.starts_with?(key, "step-") end)

    document = %{
      sequential: Map.get(params, "sequential", true),
      steps: Enum.map(Map.values(steps), fn val -> %{name: val} end)
    }

    checklist_params = checklist_params
      |> Map.put("user_id", conn.assigns.current_user.id)
      |> Map.put("document", document)

    case Checklists.create_checklist(checklist_params) do
      {:ok, checklist} ->
        conn
        |> put_flash(:info, "Checklist created successfully.")
        |> redirect(to: ~p"/checklists/#{checklist}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    checklist = Checklists.get_checklist!(id)
    render(conn, :show, checklist: checklist)
  end

  def update(conn, %{"id" => id, "checklist" => checklist_params}) do
    checklist = Checklists.get_checklist!(id)

    case Checklists.update_checklist(checklist, checklist_params) do
      {:ok, checklist} ->
        conn
        |> put_flash(:info, "Checklist updated successfully.")
        |> redirect(to: ~p"/checklists/#{checklist}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, checklist: checklist, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    checklist = Checklists.get_checklist!(id)
    {:ok, _checklist} = Checklists.delete_checklist(checklist)

    conn
    |> put_flash(:info, "Checklist deleted successfully.")
    |> redirect(to: ~p"/checklists")
  end
end
