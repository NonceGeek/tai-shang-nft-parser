# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tai_shang_nft_parser,
  ecto_repos: [TaiShangNftParser.Repo]

# Configures the endpoint
config :tai_shang_nft_parser, TaiShangNftParserWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gEK+FDQ1h9Xz3N0azzPcWbSVM90ztwzKTL/1zemY/0XfxgwymPdasKOR9QpT/NMA",
  render_errors: [view: TaiShangNftParserWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TaiShangNftParser.PubSub,
  live_view: [signing_salt: "w6b58jwy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
