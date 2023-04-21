import Config

# Configure your database
config :car_leasing, CarLeasing.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "car_leasing_db",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  seed: true

config :car_leasing, CarLeasingWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "HlCEC0gWr+VS8SGPfBZKmCLOxtIrGtrwwaL9uteDI8/F8SbP0K8C6Dd8+vzhOyjI",
  watchers: []

# Enable dev routes for dashboard and mailbox
config :car_leasing, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
