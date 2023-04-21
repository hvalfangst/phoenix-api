defmodule CarLeasing.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CarLeasingWeb.Telemetry,
      # Start the Ecto repository
      CarLeasing.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: CarLeasing.PubSub},
      # Start the Endpoint (http/https)
      CarLeasingWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: CarLeasing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Update the endpoint configuration on changes
  @impl true
  def config_change(changed, _new, removed) do
    CarLeasingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
