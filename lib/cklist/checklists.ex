defmodule Cklist.Checklists do
  @moduledoc """
  The Checklists context.
  """

  import Ecto.Query, warn: false
  alias Cklist.Checklists.Run
  alias Cklist.Checklists.Activity
  alias Cklist.Checklists.Checklist
  alias Cklist.Repo

  @doc """
  Returns the list of checklists.

  ## Examples

      iex> list_checklists()
      [%Checklist{}, ...]

  """
  def list_checklists(nil) do
    query = from l in Checklist, where: l.access == :public
    Repo.all(query)
  end
  def list_checklists(user) do
    query = from l in Checklist, where: l.user_id == ^user.id or l.access == :public
    Repo.all(query)
  end


  @doc """
  Gets a single checklist.

  Raises `Ecto.NoResultsError` if the Checklist does not exist.

  ## Examples

      iex> get_checklist!(123)
      %Checklist{}

      iex> get_checklist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checklist!(id), do: Repo.get!(Checklist, id)

  @doc """
  Creates a checklist.

  ## Examples

      iex> create_checklist(%{field: value})
      {:ok, %Checklist{}}

      iex> create_checklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checklist(attrs \\ %{}) do
    %Checklist{}
    |> Checklist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a checklist.

  ## Examples

      iex> update_checklist(checklist, %{field: new_value})
      {:ok, %Checklist{}}

      iex> update_checklist(checklist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checklist(%Checklist{} = checklist, attrs) do
    checklist
    |> Checklist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a checklist.

  ## Examples

      iex> delete_checklist(checklist)
      {:ok, %Checklist{}}

      iex> delete_checklist(checklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checklist(%Checklist{} = checklist) do
    Repo.delete(checklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checklist changes.

  ## Examples

      iex> change_checklist(checklist)
      %Ecto.Changeset{data: %Checklist{}}

  """
  def change_checklist(%Checklist{} = checklist, attrs \\ %{}) do
    Checklist.changeset(checklist, attrs)
  end

  def log_run_start(checklist, user) do
    {:ok, run} = %Run{}
      |> Run.changeset(%{checklist_id: checklist.id})
      |> Repo.insert()

    %Activity{}
      |> Activity.changeset(%{run_id: run.id, user_id: user.id, event: %{type: "checklist_start"}})
      |> Repo.insert()

    # return current run
    run
  end

  def log_run_abort(run, user) do
    %Activity{}
      |> Activity.changeset(%{run_id: run.id, user_id: user.id, event: %{type: "checklist_abort"}})
      |> Repo.insert()
  end

  def log_run_complete(run, user) do
    %Activity{}
      |> Activity.changeset(%{run_id: run.id, user_id: user.id, event: %{type: "checklist_complete"}})
      |> Repo.insert()
  end

  def log_step_complete(run, user, step_id, is_done \\ true) do
    %Activity{}
      |> Activity.changeset(%{run_id: run.id, user_id: user.id, event: %{type: "step_done", step_id: step_id, done: is_done}})
      |> Repo.insert()
  end
end
