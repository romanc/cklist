defmodule Cklist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CklistWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:cklist, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cklist.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Cklist.Finch},
      # Start a worker by calling: Cklist.Worker.start_link(arg)
      # {Cklist.Worker, arg},
      # Start to serve requests, typically the last entry
      CklistWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cklist.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CklistWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
