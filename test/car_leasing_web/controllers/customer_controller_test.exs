defmodule CarLeasingWeb.CustomerControllerTest do
  use CarLeasingWeb.ConnCase

  alias CarLeasing.Customer
  alias CarLeasingWeb.Factory

  describe "GET api/customers" do
    test "returns list with two customers on existing data", %{conn: conn} do
      # Insert cars to DB
      {first_customer_id, _} = Factory.insert_customer()

      {second_customer_id, _} =
        Factory.insert_customer(%Customer{first_name: "Ernst", email: "ernst@gmail.com"})

      # Execute GET api/customers
      conn = get(conn, "/api/customers")

      # Assert that the JSON response corresponds to our newly inserted data
      assert [
               %{
                 "id" => ^first_customer_id,
                 "email" => "jane.doe@example.com",
                 "first_name" => "Jane",
                 "last_name" => "Doe",
                 "phone_number" => "555-4321"
               },
               %{
                 "id" => ^second_customer_id,
                 "email" => "ernst@gmail.com",
                 "first_name" => "Ernst",
                 "last_name" => nil,
                 "phone_number" => nil
               }
             ] = json_response(conn, 200)
    end

    test "returns empty list on no data", %{conn: conn} do
      # Execute GET api/cars
      conn = get(conn, "/api/customers")

      # Assert that the JSON response corresponds to an empty list
      assert [] = json_response(conn, 200)
    end
  end

  describe "POST api/customers" do
    test "successfully creates new customer on valid parameters", %{conn: conn} do
      # Request parameters
      customer_params = %{
        first_name: "Jane",
        last_name: "Doe",
        phone_number: "555-4321",
        email: "jane.doe@example.com",
        password: Bcrypt.hash_pwd_salt("12345678")
      }

      # Execute POST /api/leases with customer_params as request body
      conn = post(conn, "/api/customers", %{customer: customer_params})

      # Assert that the resource was created and capture the response
      response = assert json_response(conn, 201)

      # Retrieve the customer ID with slice
      id = String.slice(response, 30..65)

      # Assert that the ID is in fact a UUID
      assert true == match?({:ok, _}, Ecto.UUID.dump(id))

      # Get customer by ID
      conn = get(conn, "/api/customers/#{id}")

      # Assert that the retrieved customer matches that of request body
      assert %{
               "email" => "jane.doe@example.com",
               "first_name" => "Jane",
               "id" => ^id,
               "last_name" => "Doe",
               "phone_number" => "555-4321"
             } = json_response(conn, 200)
    end

    test "returns 422 with changeset errors on invalid input", %{conn: conn} do
      illegal_value = "COOKIECUTTER"

      customer_params = %{
        first_name: illegal_value,
        last_name: illegal_value,
        phone_number: illegal_value,
        email: illegal_value,
        password: illegal_value
      }

      # Create a new customer based on the above, illegal parameters
      conn = post(conn, "/api/customers", %{customer: customer_params})

      # Assert that the retrieved lease matches that of fields declared
      assert %{
               "changeset_errors" => %{
                 "email" => "must be a valid email address"
               }
             } = json_response(conn, 422)
    end
  end

  describe "PUT api/customers/:id" do
    test "updates customer on valid parameters", %{conn: conn} do
      # Insert a new customer to DB
      {customer_id, customer} = Factory.insert_customer()

      updated_phone_number = "666-6666"

      # Update existing field "phone_number" with the above
      updated_customer = %{
        first_name: customer.first_name,
        last_name: customer.last_name,
        phone_number: updated_phone_number,
        email: customer.email,
        password: customer.password
      }

      # Execute PUT api/customers
      conn = put(conn, "/api/customers/#{customer_id}", %{customer: updated_customer})

      # Assert success of PUT
      assert json_response(conn, 200)

      # Get customer by ID
      conn = get(conn, "/api/customers/#{customer_id}")

      # Assert that the car is indeed updated
      assert %{
               "email" => "jane.doe@example.com",
               "first_name" => "Jane",
               "id" => ^customer_id,
               "last_name" => "Doe",
               "phone_number" => ^updated_phone_number
             } = json_response(conn, 200)
    end

    test "returns 404 on non-existing car", %{conn: conn} do
      random_uuid = Ecto.UUID.generate()

      # Get car by ID declared above
      conn = put(conn, "/api/customers/#{random_uuid}", %{customer: nil})

      # Assert that the retrieved car matches that of fields declared
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end
  end

  describe "DELETE api/customers/:id" do
    test "deletes customer on valid, existing ID", %{conn: conn} do
      # Insert a new car to DB
      {customer_id, _} = Factory.insert_customer()

      # Assert the existence of newly created car
      conn = get(conn, "/api/customers/#{customer_id}")
      assert json_response(conn, 200)

      # Delete aforementioned car
      conn = delete(conn, "/api/customers/#{customer_id}")

      # Assert success of delete operation
      response = assert json_response(conn, 200)

      # Extract car ID from response with slice
      id = String.slice(response, 25..60)

      # Assert that the extracted ID conforms to UUID
      assert true == match?({:ok, _}, Ecto.UUID.dump(id))

      # Assert that the two car ID matches
      assert customer_id == id

      # Assert lack of existence of our newly deleted cars
      conn = get(conn, "/api/customers/#{customer_id}")
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end

    test "returns 422 on invalid customer ID format", %{conn: conn} do
      not_an_uuid = "DUDE"

      # Get car by ID
      conn = delete(conn, "/api/customers/#{not_an_uuid}")

      # Assert mismatch
      assert %{"error" => "The string DUDE is not an UUID"} = json_response(conn, 422)
    end

    test "returns 404 on non-existing customer", %{conn: conn} do
      random_uuid = Ecto.UUID.generate()

      # Get car by ID
      conn = delete(conn, "/api/customers/#{random_uuid}")

      # Assert that the retrieved car matches that of fields declared
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end
  end

  # TODO: Create fallback case for when request body struct is malformed
end
