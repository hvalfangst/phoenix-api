import Config

config :car_leasing, CarLeasing.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "car_leasing_db_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  seed: false

config :car_leasing, CarLeasingWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Wyi9JlJ2GfT6r3kLhOTVBWxe0RsJ/YUQufUYP8AA/vRHKcpze5rd1ebAe8owIDLU",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
