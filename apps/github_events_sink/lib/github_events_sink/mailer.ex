defmodule GithubEventsSink.Mailer do
  @moduledoc """
  The Mailer module
  """

  use Swoosh.Mailer, otp_app: :github_events_sink
end
