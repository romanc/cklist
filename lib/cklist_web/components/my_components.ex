defmodule CklistWeb.MyComponents do
  @moduledoc """
  Provides custom UI components for the Cklist project.
  """

  use Phoenix.Component
  import CklistWeb.CoreComponents

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

  def sequential_run(assigns) do
    ~H"""
    <div :if={@checklist.document["sequential"]}>
      <div class="mt-4" >
        <%= if @completed do %>
          <p>Look at all the things you did:</p>
          <ul class="mt-2 list-disc list-inside">
            <%= for step <- @checklist.document["steps"] do %>
              <li><%= step["name"] %></li>
            <% end %>
          </ul>
        <% else %>
          <.card title={@current_step["name"]} description={Map.get(@current_step, "description", "")} />
          <%= if @next_step do %>
            <.preview_card title={@next_step["name"]} />
          <% end %>
        <% end %>
      </div>

      <div class={"flex flex-row my-8 #{if @completed, do: "justify-end", else: "justify-between"}"}>
        <.abort_button class="basis-1/3" hidden={@completed} />

        <.next_button class="basis-1/3" :if={@completed}>
          <%= if @completed, do: "Awesome!" %>
        </.next_button>
      </div>
    </div>
    """
  end

  def checklist_run(assigns) do
    ~H"""
    <div :if={not @checklist.document["sequential"]}>
      <form id="checklist_run_form">
        <.input
          :for={step <- @checklist.document["steps"]}
          phx-change="step_done"
          checked={Map.get(@step_state, step["name"], false)}
          id={step["name"]}
          type="checkbox" label={"#{step["name"]}: #{Map.get(step, "description", "")}"}
          name={step["name"]}
          disabled={@completed}
        />
      </form>

      <div class={"mt-4 #{if @completed, do: "", else: "hidden"}"}>
        <p class="text-xl">Congratulations! 🎉</p>
        <p class="text-zinc-600 text-medium mt-1">You finished the checklist.</p>
      </div>

      <div class={"flex flex-row my-8 #{if @completed, do: "justify-end", else: "justify-between"}"}>
        <.abort_button class="basis-1/3" hidden={@completed} />

        <.next_button class="basis-1/3" hidden={not @completed}>
          Awesome!
        </.next_button>
      </div>
    </div>
    """
  end

  @doc """
  Renders one step of a sequential checklist as a card.

  ## Example

    <.card title="My card" description="Lorem ipsum dolor sit amet..." />
  """
  attr :title, :string, required: true
  attr :description, :string, required: false
  def card(assigns) do
    ~H"""
    <div class="shadow-md p-4" id="checklist_card">
        <p class="text-lg"><%= @title %></p>
        <%= if @description do %>
          <p><%= @description %></p>
        <% end %>
        <div class={"flex flex-row justify-end"}>
          <.next_button class="basis-1/3" />
        </div>
      </div>
    """
  end

  @doc """
  Renders a preview of one step of the next step of a sequential checklist

  ## Example

    <.preview_card title="My preview card" />
  """
  def preview_card(assigns) do
    ~H"""
    <div class="shadow-md p-4" id="checklist_preview-card">
      <p class="text-sm"><%= @title %></p>
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
      class={"#{if @hidden, do: "hidden", else: ""} #{@class}"}
      phx-click="abort"
      data-confirm="Are you sure you want to abort this checklist?"
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
  slot :inner_block, required: false

  def next_button(assigns) do
    ~H"""
    <.button
      class={"#{if @hidden, do: "hidden", else: ""} #{@class}"}
      phx-click="next_step"
    >
      <%= render_slot(@inner_block) || "Next" %>
    </.button>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, doc: "Arbitrary HTML attributes to apply to the button tag"
  slot :inner_block, required: true
  def my_button(assigns) do
    ~H"""
    <.core_button
      type="button"
      class={"px-2 #{@class}"}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.core_button>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, doc: "Arbitrary HTML attributes to apply to the button tag"
  slot :inner_block, required: true
  defp core_button(assigns) do
    ~H"""
    <button class={"rounded-lg py-2 border-2 hover:border-slate-400 #{@class}"} {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
