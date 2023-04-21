defmodule CarLeasingWeb.FallbackController do
  use CarLeasingWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{errors: [_ | _] = errors}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{changeset_errors: map_errors_to_struct(errors)})
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "Resource not found"})
  end

  def call(conn, {:error, message}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: message})
  end

  def map_errors_to_struct(errors) do
    Enum.reduce(errors, %{}, fn {field, {message, _}}, acc ->
      Map.put(acc, field, message)
    end)
  end
end
