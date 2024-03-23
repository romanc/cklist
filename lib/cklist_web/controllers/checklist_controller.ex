defmodule CklistWeb.ChecklistController do
  use CklistWeb, :controller

  alias Cklist.Checklists

  def index(conn, _params) do
    checklists = Checklists.list_checklists(conn.assigns.current_user)
    render(conn, :index, checklists: checklists)
  end

  def create(conn, %{"checklist" => checklist_params}) do
    data = %{}
    |> Map.put("sequential", Map.get(checklist_params, "sequential"))
    |> Map.put("steps", Map.get(checklist_params, "steps", []))

    checklist_params = checklist_params
    |> Map.put("user_id", conn.assigns.current_user.id)
    |> Map.put("document", data)

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

  def edit(conn, %{"id" => id}) do
    checklist = Checklists.get_checklist!(id)
    changeset = Checklists.change_checklist(checklist)
    render(conn, :edit, checklist: checklist, changeset: changeset)
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
