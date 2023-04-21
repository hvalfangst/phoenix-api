defmodule CarLeasing.Lease do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder,
           only: [
             :id,
             :monthly_payment,
             :current_mileage,
             :mileage_limit,
             :start_date,
             :end_date,
             :car,
             :customer
           ]}
  schema "leases" do
    field :monthly_payment, :integer
    field :current_mileage, :integer
    field :mileage_limit, :integer
    field :start_date, :date
    field :end_date, :date

    belongs_to :car, CarLeasing.Car, foreign_key: :car_id, type: :binary_id
    belongs_to :customer, CarLeasing.Customer, foreign_key: :customer_id, type: :binary_id

    timestamps()
  end

  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [
      :monthly_payment,
      :current_mileage,
      :mileage_limit,
      :start_date,
      :end_date,
      :car_id,
      :customer_id
    ])
    |> validate_required([
      :monthly_payment,
      :current_mileage,
      :mileage_limit,
      :start_date,
      :end_date,
      :car_id,
      :customer_id
    ])
    |> validate_number(:monthly_payment, greater_than: 0)
    |> validate_number(:current_mileage, greater_than_or_equal_to: 0)
    |> validate_number(:mileage_limit, greater_than: 0)
  end
end
