defmodule CarLeasingWeb.LeaseController do
  use CarLeasingWeb, :controller

  alias CarLeasing
  action_fallback CarLeasingWeb.FallbackController

  def index(conn, _params) do
    with lease <- CarLeasing.list_leases() do
      conn
      |> put_status(:ok)
      |> json(lease)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, lease} <- CarLeasing.get_lease_by_id(id) do
      conn
      |> put_status(:ok)
      |> json(lease)
    end
  end

  def create(conn, %{"lease" => lease_params}) do
    with {:ok, lease} <- CarLeasing.create_lease(lease_params) do
      conn
      |> put_status(:created)
      |> json("Lease has been created with ID #{lease.id}")
    end
  end

  def update(conn, %{"id" => id, "lease" => lease_params}) do
    with {:ok, lease} <- CarLeasing.get_lease_by_id(id),
         {:ok, _} <- CarLeasing.update_lease(lease, lease_params) do
      conn
      |> put_status(:ok)
      |> json("Lease associated with UUID #{id} has been updated")
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, car} <- CarLeasing.get_lease_by_id(id),
         {:ok, :deleted} <- CarLeasing.delete_lease(car) do
      conn
      |> put_status(:ok)
      |> json("Lease associated with UUID #{id} has been deleted")
    end
  end
end
