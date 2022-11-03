# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :github_events_sink,
  ecto_repos: [GithubEventsSink.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :github_events_sink, GithubEventsSink.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :github_events_sink_web,
  ecto_repos: [GithubEventsSink.Repo],
  generators: [context_app: :github_events_sink]

# Configures the endpoint
config :github_events_sink_web, GithubEventsSinkWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: GithubEventsSinkWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GithubEventsSink.PubSub,
  live_view: [signing_salt: "Y7QisnVs"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/github_events_sink_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
elixir_logger_level = System.get_env("ELIXIR_LOGGER_LEVEL", "info")

level =
  %{
    "1" => :debug,
    "2" => :info,
    "3" => :warn,
    "debug" => :debug,
    "info" => :info,
    "warn" => :warn
  }
  |> Map.get(String.downcase(elixir_logger_level), :info)

# Configures Elixir's Logger
config :logger, :console,
  level: level,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
