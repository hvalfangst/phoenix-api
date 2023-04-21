defmodule CarLeasing.Repo.Migrations.CreateLeases do
  use Ecto.Migration

  def change do
    create table(:leases, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :monthly_payment, :integer
      add :current_mileage, :integer
      add :mileage_limit, :integer
      add :start_date, :date
      add :end_date, :date

      add :car_id, references(:cars, column: :id, type: :uuid)
      add :customer_id, references(:customers, column: :id, type: :uuid)

      timestamps()
    end
  end
end
