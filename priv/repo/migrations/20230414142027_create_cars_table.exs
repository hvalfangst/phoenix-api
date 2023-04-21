defmodule CarLeasing.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :make, :string
      add :model, :string
      add :year, :integer
      add :price, :decimal
      add :mileage, :integer
      add :fuel, :string
      add :horsepower, :integer

      timestamps()
    end

    create unique_index(:cars, [:make, :model, :year, :price, :mileage, :fuel, :horsepower],
             name: :unique_cars_fields
           )
  end
end
