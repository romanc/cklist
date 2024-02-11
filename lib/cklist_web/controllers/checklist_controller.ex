defmodule CklistWeb.ChecklistController do
  use CklistWeb, :controller

  alias Cklist.Checklists
  alias Cklist.Checklists.Checklist

  def index(conn, _params) do
    checklists = Checklists.list_checklists(conn.assigns.current_user)
    render(conn, :index, checklists: checklists)
  end

  def new(conn, _params) do
    changeset = Checklists.change_checklist(%Checklist{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"checklist" => checklist_params}) do
    checklist_params = Map.put(checklist_params, "user_id", conn.assigns.current_user.id)
    checklist_params = Map.put(checklist_params, "document", %{
      version: "0.1",
      sequential: false,
      steps: [
        %{ name: "one thing" },
        %{ name: "that other thing" }
      ]})

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
