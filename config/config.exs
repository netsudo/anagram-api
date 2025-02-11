# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :anagram, AnagramWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+XEIJUCnpxyBJnZ7z9vXoBpcl6qtVSW1p28l5G70hd9I4h+mnREZPc3dyhobLULf",
  render_errors: [view: AnagramWeb.ErrorView, format: "json", accepts: ~w(json)],
  pubsub: [name: Anagram.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
