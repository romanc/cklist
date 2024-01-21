import Config
import Dotenvy

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/cklist start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
config_dir_prefix =
  case System.fetch_env("RELEASE_ROOT") do
    :error ->
      "envs/"

    {:ok, value} ->
      "#{value}/"
  end

source!([
  "#{config_dir_prefix}.env",
  "#{config_dir_prefix}.#{config_env()}.env",
  "#{config_dir_prefix}.#{config_env()}.local.env",
  System.get_env()
])

if env!("PHX_SERVER", :boolean, false) do
  config :cklist, CklistWeb.Endpoint, server: true
end

if config_env() == :dev do
  config :cklist, Cklist.Repo,
    url: env!("DATABASE_URL", :string, "ecto://cklist:cklist@localhost/cklist_dev")
end

if config_env() == :prod do
  database_url = env!("DATABASE_URL")
  maybe_ipv6 = if env!("ECTO_IPV6", :boolean, false), do: [:inet6], else: []

  config :cklist, Cklist.Repo,
    # ssl: true,
    url: database_url,
    pool_size: env!("POOL_SIZE", :integer, 10),
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    env!("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :cklist, :dns_cluster_query, env!("DNS_CLUSTER_QUERY", :string, nil)

  config :cklist, CklistWeb.Endpoint,
    url: [host: env!("HTTP_HOSTNAME", :string, "example.com"), port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: env!("HTTP_PORT", :integer, 4000)
    ],
    secret_key_base: secret_key_base

  # ## SSL Support
  #
  # To get SSL working, you will need to add the `https` key
  # to your endpoint configuration:
  #
  #     config :cklist, CklistWeb.Endpoint,
  #       https: [
  #         ...,
  #         port: 443,
  #         cipher_suite: :strong,
  #         keyfile: env!("SOME_APP_SSL_KEY_PATH", :string),
  #         certfile: env!("SOME_APP_SSL_CERT_PATH", :string)
  #       ]
  #
  # The `cipher_suite` is set to `:strong` to support only the
  # latest and more secure SSL ciphers. This means old browsers
  # and clients may not be supported. You can set it to
  # `:compatible` for wider support.
  #
  # `:keyfile` and `:certfile` expect an absolute path to the key
  # and cert in disk or a relative path inside priv, for example
  # "priv/ssl/server.key". For all supported SSL configuration
  # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
  #
  # We also recommend setting `force_ssl` in your endpoint, ensuring
  # no data is ever sent via http, always redirecting to https:
  #
  #     config :cklist, CklistWeb.Endpoint,
  #       force_ssl: [hsts: true]
  #
  # Check `Plug.SSL` for all available options in `force_ssl`.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :cklist, Cklist.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
  #
  if env!("SMTP", :boolean, false) do
    config :cklist, CKList.Mailer,
      adapter: Swoosh.Adapters.SMTP,
      hostname: env!("SMTP_HOSTNAME"),
      relay: env!("SMTP_HOST"),
      username: env!("SMTP_USER"),
      port: env!("SMTP_PORT"),
      password: env!("SMTP_PASSWORD"),
      tls: :always,
      auth: :always,
      retries: 5,
      no_mx_lookups: false,
      tls_options: [
        verify: :verify_peer,
        cacerts: :certifi.cacerts(),
        server_name_indication: String.to_charlist(env!("SMTP_HOST")),
        depth: 99
      ]
  end
end
