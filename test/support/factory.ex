defmodule CarLeasingWeb.Factory do
  alias CarLeasing.{Repo, Car, Customer, Lease}

  def insert_car(%Car{} = params) do
    insert(Map.merge(car_template(), params))
  end

  def insert_car(), do: insert(car_template())

  def insert_customer(%Customer{} = params) do
    insert(Map.merge(customer_template(), params))
  end

  def insert_customer(), do: insert(customer_template())

  def insert_lease(%Lease{} = params, car_id, customer_id) do
    insert(Map.merge(leases_template(car_id, customer_id), params))
  end

  def insert_lease(car_id, customer_id), do: insert(leases_template(car_id, customer_id))

  def insert(struct) do
    {:ok, ecto_struct} = struct |> Repo.insert()
    {ecto_struct.id, ecto_struct}
  end

  # - - - - - - - - - - - - - - - TEMPLATES  - - - - - - - - - - - - - - - -

  def car_template() do
    %Car{
      make: "Toyota",
      model: "Camry",
      year: 2020,
      price: 20000,
      mileage: 15000,
      fuel: "gas",
      horsepower: 203
    }
  end

  def customer_template() do
    %Customer{
      first_name: "Jane",
      last_name: "Doe",
      phone_number: "555-4321",
      email: "jane.doe@example.com",
      password: Bcrypt.hash_pwd_salt("12345678")
    }
  end

  def leases_template(car_id, customer_id) do
    %Lease{
      car_id: car_id,
      customer_id: customer_id,
      monthly_payment: 600,
      current_mileage: 8000,
      mileage_limit: 12000,
      start_date: ~D[2022-02-15],
      end_date: ~D[2022-08-15]
    }
  end
end
