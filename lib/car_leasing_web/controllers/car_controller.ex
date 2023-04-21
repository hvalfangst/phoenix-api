defmodule CarLeasingWeb.CarController do
  use CarLeasingWeb, :controller

  alias CarLeasing
  action_fallback CarLeasingWeb.FallbackController

  def index(conn, _params) do
    with cars <- CarLeasing.list_cars() do
      conn
      |> put_status(:ok)
      |> json(cars)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, car} <- CarLeasing.get_car_by_id(id) do
      conn
      |> put_status(:ok)
      |> json(car)
    end
  end

  def create(conn, %{"car" => car_params}) do
    with {:ok, car} <- CarLeasing.create_car(car_params) do
      conn
      |> put_status(:created)
      |> json("Car has been with created with UUID #{car.id}")
    end
  end

  def update(conn, %{"id" => id, "car" => car_params}) do
    with {:ok, car} <- CarLeasing.get_car_by_id(id),
         {:ok, _} <- CarLeasing.update_car(car, car_params) do
      conn
      |> put_status(:ok)
      |> json("Car associated with UUID #{id} has been updated")
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, car} <- CarLeasing.get_car_by_id(id),
         _ <- CarLeasing.delete_car(car) do
      conn
      |> put_status(:ok)
      |> json("Car associated with UUID #{id} has been deleted")
    end
  end
end
