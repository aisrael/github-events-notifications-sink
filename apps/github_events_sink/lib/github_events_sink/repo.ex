defmodule GithubEventsSink.Repo do
  use Ecto.Repo,
    otp_app: :github_events_sink,
    adapter: Ecto.Adapters.Postgres
end
