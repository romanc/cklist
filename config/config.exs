# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :cklist,
  ecto_repos: [Cklist.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :cklist, CklistWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: CklistWeb.ErrorHTML, json: CklistWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Cklist.PubSub,
  live_view: [signing_salt: "z+y9ggBr"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :cklist, Cklist.Mailer, adapter: Swoosh.Adapters.Local

config :ex_cldr,
  default_backend: Cklist.Cldr

config :cklist, CklistWeb.Cldr,
  default_locale: "en",
  locales: ["en"],
  gettext: Cklist.Gettext,
  data_dir: "./priv/cldr",
  precompile_number_formats: ["¤¤#,##0.##", "#,##0"],
  precompile_transliterations: [],
  providers: [Cldr.Calendar, Cldr.DateTime, Cldr.Number, Cldr.Unit]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.ts --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
