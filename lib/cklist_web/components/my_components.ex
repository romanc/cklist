defmodule CklistWeb.MyComponents do
  @moduledoc """
  Provides custom UI components for the Cklist project.
  """

  use Phoenix.Component

  @doc """
  Renders a progress bar.

  ## Example

    <.progress_bar steps=5 done=2 />
  """
  attr :steps, :integer, required: true
  attr :done, :integer, required: true

  def progress_bar(assigns) do
    ~H"""
    <div class="my-8 w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700" id="checklist_progress">
      <div class="bg-blue-600 h-2.5 rounded-full" style={"width: #{@done/@steps * 100}%"}></div>
    </div>
    """
  end
end
