import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :splitmore, Splitmore.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "splitmore_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :splitmore, SplitmoreWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "kIKFO1BibwSi15WhT6FsU/UV+C+J3n1GDqHsk1UGa7wSgoACbf/dGKDNTWHaDbu7",
  check_origin: false,
  # enables server for e2e tests
  server: true

# In test we don't send emails.
config :splitmore, Splitmore.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
