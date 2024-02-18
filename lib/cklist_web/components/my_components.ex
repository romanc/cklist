defmodule CklistWeb.MyComponents do
  @moduledoc """
  Provides custom UI components for the CKlist project.
  """

  use Phoenix.Component

  @doc """
  Renders a progress bar.

  ## Example

    <.progress percent="45" />
  """
  attr :done, :integer, required: true
  attr :steps, :integer, required: true

  def progress(assigns) do
    ~H"""
    <%= @done %> / <%= @steps %>
    <div class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
      <div class="bg-blue-600 h-2.5 rounded-full" style={"width: #{@done/@steps*100}%"}></div>
    </div>
    """
  end
end
