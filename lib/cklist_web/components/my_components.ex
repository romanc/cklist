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

  @doc """
  Renders one step of a sequential checklist as a card.
  """
  def card(assigns) do
    ~H"""
    <div class="shadow-md p-4">
        <p class="text-lg"><%= render_slot(@inner_block) %></p>
        <div class={"flex flex-row justify-end"}>
          <.next_button class="basis-1/3">Done</.next_button>
        </div>
      </div>
    """
  end

  @doc """
  Renders a preview of one step of the next step of a sequential checklist
  """
  def preview_card(assigns) do
    ~H"""
    <div class="shadow-md p-4">
      <p class="text-sm"><%= render_slot(@inner_block) %></p>
    </div>
    """
  end

  @doc """
  Renders an abort button.

  ## Example

    <.abort_button hidden={@completed} />
  """
  attr :class, :string, default: nil
  attr :hidden, :boolean, default: false

  def abort_button(assigns) do
    ~H"""
    <.button
      class={"bg-gray-300 hover:bg-gray-400 #{if @hidden, do: "hidden", else: ""} #{@class}"}
      phx-click="abort"
      data-confirm="Are you sure?"
    >
      Abort
    </.button>
    """
  end

  @doc """
  Renders a button to go to the next step.

  ## Example

    <.next_button hidden={not @completed}>
      Awesome!
    </.next_button>
  """
  attr :class, :string, default: nil
  attr :hidden, :boolean, default: false
  slot :inner_block, default: "Next"

  def next_button(assigns) do
    ~H"""
    <.button
      class={"bg-lime-500 hover:bg-lime-400 #{if @hidden, do: "hidden", else: ""} #{@class}"}
      phx-click="next_step"
    >
      <%= render_slot(@inner_block) %>
    </.button>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, doc: "arbitrary HTML attributes to apply to the button tag"
  slot :inner_block, required: true
  def my_button(assigns) do
    ~H"""
    <.button
      type="button"
      class={"px-2 #{@class}"}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.button>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, doc: "arbitrary HTML attributes to apply to the button tag"
  slot :inner_block, required: true
  defp button(assigns) do
    ~H"""
    <button class={"py-2 rounded-full #{@class}"} {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
