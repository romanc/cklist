defmodule CklistWeb.ChecklistHTML do
  use CklistWeb, :html

  embed_templates "checklist_html/*"

  @doc """
  Renders a checklist form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def checklist_form(assigns)
end
