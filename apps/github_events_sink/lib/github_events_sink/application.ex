defmodule GithubEventsSink.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GithubEventsSink.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GithubEventsSink.PubSub}
      # Start a worker by calling: GithubEventsSink.Worker.start_link(arg)
      # {GithubEventsSink.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: GithubEventsSink.Supervisor)
  end
end
