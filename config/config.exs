# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :quiz_site,
  ecto_repos: [QuizSite.Repo]

# Configures the endpoint
config :quiz_site, QuizSiteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bnyYSMFISETKVSqkY58yMkNEy3frGKfZzHLiA4hqS3i1dCEZxfB7mTc88ZOY/OBc",
  render_errors: [view: QuizSiteWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: QuizSite.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :quiz_site,
  page_title_suffix: "Celebrity Financial Twin Quiz"
