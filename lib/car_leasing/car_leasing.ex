defmodule CarLeasing do
  alias CarLeasing.{Repo, Car, Customer, Lease}
  import Ecto.Query, only: [from: 2]
  import CarLeasing.Utils, only: [is_uuid: 1]

  # - - - - - - - - - - - - - - - CARS  - - - - - - - - - - - - - - - -

  def list_cars() do
    Repo.all(Car)
  end

  def create_car(attrs \\ %{}) do
    %Car{}
    |> Car.changeset(attrs)
    |> Repo.insert()
  end

  def get_car_by_id(id) when is_uuid(id) do
    case Repo.get_by(Car, id: id) do
      nil -> {:error, :not_found}
      car -> {:ok, car}
    end
  end

  def get_car_by_id(id) do
    {:error, "The string #{id} is not an UUID"}
  end

  def update_car(car, attrs) do
    car
    |> Car.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, updated_car} -> {:ok, updated_car}
      {:error, _} -> {:error, "Failed to update car with UUID #{car.id}"}
    end
  end

  def delete_car(%Car{id: id}) do
    case from(x in Car, where: x.id == ^id) |> Repo.delete_all() do
      {1, nil} -> {:ok, :deleted}
      _ -> {:error, "Delete failed for car #{id}"}
    end
  end

  # - - - - - - - - - - - - - - - CUSTOMERS  - - - - - - - - - - - - - - - -

  def list_customers() do
    Repo.all(Customer)
  end

  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  def get_customer_by_id(id) when is_uuid(id) do
    case Repo.get_by(Customer, id: id) do
      nil -> {:error, :not_found}
      customer -> {:ok, customer}
    end
  end

  def get_customer_by_id(id) do
    {:error, "The string #{id} is not an UUID"}
  end

  def update_customer(customer, attrs) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, updated_customer} -> {:ok, updated_customer}
      {:error, _} -> {:error, "Failed to update customer with UUID #{customer.id}"}
    end
  end

  def delete_customer(%Customer{id: id}) do
    case from(x in Customer, where: x.id == ^id) |> Repo.delete_all() do
      {1, nil} -> {:ok, :deleted}
      _ -> {:error, "Delete failed for customer #{id}"}
    end
  end

  # - - - - - - - - - - - - - - - LEASES  - - - - - - - - - - - - - - - -

  def list_leases() do
    Repo.all(Lease)
    |> Repo.preload([:customer, :car])
  end

  def create_lease(attrs \\ %{}) do
    %Lease{}
    |> Lease.changeset(attrs)
    |> Repo.insert()
  end

  def get_lease_by_id(id) when is_uuid(id) do
    case Repo.get_by(Lease, id: id) do
      nil -> {:error, :not_found}
      lease -> {:ok, lease |> Repo.preload([:customer, :car])}
    end
  end

  def get_lease_by_id(id) do
    {:error, "The string #{id} is not an UUID"}
  end

  def update_lease(lease, attrs) do
    lease
    |> Lease.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, updated_lease} -> {:ok, updated_lease}
      {:error, _} -> {:error, "Failed to update lease with UUID #{lease.id}"}
    end
  end

  def delete_lease(%Lease{id: id}) do
    case from(x in Lease, where: x.id == ^id) |> Repo.delete_all() do
      {1, nil} -> {:ok, :deleted}
      _ -> {:error, "Delete failed for lease #{id}"}
    end
  end
end
