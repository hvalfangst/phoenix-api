defmodule CarLeasing.Repo do
  use Ecto.Repo,
    otp_app: :car_leasing,
    adapter: Ecto.Adapters.Postgres
end
