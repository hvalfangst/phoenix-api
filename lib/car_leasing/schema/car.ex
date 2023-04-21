defmodule CarLeasing.Car do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder, only: [:id, :make, :model, :year, :price, :mileage, :fuel, :horsepower]}
  schema "cars" do
    field :make, :string
    field :model, :string
    field :year, :integer
    field :price, :decimal
    field :mileage, :integer
    field :fuel, :string
    field :horsepower, :integer

    has_many :leases, CarLeasing.Lease

    timestamps()
  end

  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:make, :model, :year, :price, :mileage, :fuel, :horsepower])
    |> validate_required([:make, :model, :year, :price, :mileage, :fuel, :horsepower])
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:mileage, greater_than_or_equal_to: 0)
    |> unique_constraint([:make, :model, :year, :price, :mileage, :fuel, :horsepower],
      name: :unique_cars_fields,
      message: "A car with the same parameters already exists"
    )
  end
end
