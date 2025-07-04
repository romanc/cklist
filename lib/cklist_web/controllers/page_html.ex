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

  def faq(assigns) do
    ~H"""
    <div>
      <.header class="my-4">FAQ</.header>

      <dl :for={item <- @items}>
        <dt class="font-semibold my-2">{item.question}</dt>
        <dd>{item.answer}</dd>
      </dl>
    </div>
    """
  end
end
