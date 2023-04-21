defmodule CarLeasingWeb.CustomerController do
  use CarLeasingWeb, :controller

  alias CarLeasing
  action_fallback CarLeasingWeb.FallbackController

  def index(conn, _params) do
    with customers = CarLeasing.list_customers() do
      conn
      |> put_status(:ok)
      |> json(customers)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, customer} <- CarLeasing.get_customer_by_id(id) do
      conn
      |> put_status(:ok)
      |> json(customer)
    end
  end

  def create(conn, %{"customer" => customer_params}) do
    with {:ok, customer} <- CarLeasing.create_customer(customer_params) do
      conn
      |> put_status(:created)
      |> json("Customer associated with UUID #{customer.id} has been created")
    end
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    with {:ok, customer} <- CarLeasing.get_customer_by_id(id),
         {:ok, _} <- CarLeasing.update_customer(customer, customer_params) do
      conn
      |> put_status(:ok)
      |> json("Customer associated with UUID #{id} has been updated")
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, car} <- CarLeasing.get_customer_by_id(id),
         _ <- CarLeasing.delete_customer(car) do
      conn
      |> put_status(:ok)
      |> json("Car associated with UUID #{id} has been deleted")
    end
  end
end
