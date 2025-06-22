defmodule CklistWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use CklistWeb, :html

  embed_templates "page_html/*"

  attr :title, :string, required: true
  attr :desc, :string, default: nil

  def awesome(assigns) do
    ~H"""
    <div class="flex items-start my-4">
      <img src={~p"/images/logo.svg"} width="30" />
      <div class="ml-4">
        <p class="text-lg text-zinc-600">{@title}</p>
        <p :if={@desc} class="mt-2 text-sm">{@desc}</p>
      </div>
    </div>
    """
  end
end
