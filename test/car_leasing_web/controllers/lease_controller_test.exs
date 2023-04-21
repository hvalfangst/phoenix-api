defmodule CarLeasingWeb.LeaseControllerTest do
  use CarLeasingWeb.ConnCase

  alias CarLeasing.{Car, Customer}
  alias CarLeasingWeb.Factory

  describe "GET api/leases" do
    test "returns list with two leases that have car and customer assocs", %{conn: conn} do
      # Insert cars, customers and leases to DB
      {first_car_id, _} = Factory.insert_car()
      {first_customer_id, _} = Factory.insert_customer()
      {first_lease_id, _} = Factory.insert_lease(first_car_id, first_customer_id)

      {second_car_id, _} = Factory.insert_car(%Car{make: "Ford", model: "Mustang"})

      {second_customer_id, _} =
        Factory.insert_customer(%Customer{first_name: "Ernst", email: "ernst@gmail.com"})

      {second_lease_id, _} = Factory.insert_lease(second_car_id, second_customer_id)

      # Execute GET /api/leases
      conn = get(conn, "/api/leases")

      # Assert that the JSON response corresponds to our DB inserts
      assert [
               %{
                 "car" => %{
                   "fuel" => "gas",
                   "horsepower" => 203,
                   "make" => "Toyota",
                   "mileage" => 15000,
                   "model" => "Camry",
                   "price" => "20000",
                   "year" => 2020,
                   "id" => ^first_car_id
                 },
                 "current_mileage" => 8000,
                 "customer" => %{
                   "email" => "jane.doe@example.com",
                   "first_name" => "Jane",
                   "last_name" => "Doe",
                   "phone_number" => "555-4321",
                   "id" => ^first_customer_id
                 },
                 "end_date" => "2022-08-15",
                 "mileage_limit" => 12000,
                 "monthly_payment" => 600,
                 "start_date" => "2022-02-15",
                 "id" => ^first_lease_id
               },
               %{
                 "car" => %{
                   "fuel" => nil,
                   "horsepower" => nil,
                   "make" => "Ford",
                   "mileage" => nil,
                   "model" => "Mustang",
                   "price" => nil,
                   "year" => nil,
                   "id" => ^second_car_id
                 },
                 "current_mileage" => 8000,
                 "customer" => %{
                   "email" => "ernst@gmail.com",
                   "first_name" => "Ernst",
                   "last_name" => nil,
                   "phone_number" => nil,
                   "id" => ^second_customer_id
                 },
                 "end_date" => "2022-08-15",
                 "mileage_limit" => 12000,
                 "monthly_payment" => 600,
                 "start_date" => "2022-02-15",
                 "id" => ^second_lease_id
               }
             ] = json_response(conn, 200)
    end

    test "returns empty list on no data", %{conn: conn} do
      # Execute GET /api/leases
      conn = get(conn, "/api/leases")

      # Assert that the JSON response corresponds to an empty list
      assert [] = json_response(conn, 200)
    end
  end

  describe "POST api/leases" do
    test "successfully creates new lease on valid parameters", %{conn: conn} do
      # Populate DB with car, customer and lease data
      {car_id, _} = Factory.insert_car()
      {customer_id, _} = Factory.insert_customer()

      # Create a new lease and associate it with our newly created resources
      lease_params = %{
        car_id: car_id,
        customer_id: customer_id,
        monthly_payment: 600,
        current_mileage: 8000,
        mileage_limit: 12000,
        start_date: ~D[2022-02-15],
        end_date: ~D[2022-08-15]
      }

      # Execute POST /api/leases with above params
      conn = post(conn, "/api/leases", %{lease: lease_params})

      # Assert that the resource was created and capture the response
      response = assert json_response(conn, 201)

      # Retrieve the lease ID with slice
      id = String.slice(response, 31..66)

      # Assert that the ID is in fact a UUID
      assert true == match?({:ok, _}, Ecto.UUID.dump(id))

      # Get lease by ID
      conn = get(conn, "/api/leases/#{id}")

      # Assert that the retrieved lease matches that of fields declared
      assert %{
               "car" => %{
                 "fuel" => "gas",
                 "horsepower" => 203,
                 "id" => ^car_id,
                 "make" => "Toyota",
                 "mileage" => 15000,
                 "model" => "Camry",
                 "price" => "20000",
                 "year" => 2020
               },
               "current_mileage" => 8000,
               "customer" => %{
                 "email" => "jane.doe@example.com",
                 "first_name" => "Jane",
                 "id" => ^customer_id,
                 "last_name" => "Doe",
                 "phone_number" => "555-4321"
               },
               "end_date" => "2022-08-15",
               "id" => ^id,
               "mileage_limit" => 12000,
               "monthly_payment" => 600,
               "start_date" => "2022-02-15"
             } = json_response(conn, 200)
    end

    test "returns 422 with changeset errors on invalid input", %{conn: conn} do
      # Populate DB with car, customer and lease data
      {car_id, _} = Factory.insert_car()
      {customer_id, _} = Factory.insert_customer()

      illegal_value = "ALL GAS NO BREAKS"

      # Create a new lease and associate it car and customer
      lease_params = %{
        car_id: car_id,
        customer_id: customer_id,
        monthly_payment: illegal_value,
        current_mileage: illegal_value,
        mileage_limit: illegal_value,
        start_date: illegal_value,
        end_date: illegal_value
      }

      # Create a new lease based on the above parameters
      conn = post(conn, "/api/leases", %{lease: lease_params})

      # Assert that the retrieved lease matches that of fields declared
      assert %{
               "changeset_errors" => %{
                 "current_mileage" => "is invalid",
                 "end_date" => "is invalid",
                 "mileage_limit" => "is invalid",
                 "monthly_payment" => "is invalid",
                 "start_date" => "is invalid"
               }
             } = json_response(conn, 422)
    end
  end

  describe "GET api/leases/:id" do
    test "successfully returns lease on valid lease id", %{conn: conn} do
      # Populate DB with car, customer and lease data
      {car_id, _} = Factory.insert_car()
      {customer_id, _} = Factory.insert_customer()
      {lease_id, _} = Factory.insert_lease(car_id, customer_id)

      # Get lease by ID
      conn = get(conn, "/api/leases/#{lease_id}")

      # Assert that the retrieved lease matches that of fields declared
      assert %{
               "car" => %{
                 "fuel" => "gas",
                 "horsepower" => 203,
                 "id" => ^car_id,
                 "make" => "Toyota",
                 "mileage" => 15000,
                 "model" => "Camry",
                 "price" => "20000",
                 "year" => 2020
               },
               "current_mileage" => 8000,
               "customer" => %{
                 "email" => "jane.doe@example.com",
                 "first_name" => "Jane",
                 "id" => ^customer_id,
                 "last_name" => "Doe",
                 "phone_number" => "555-4321"
               },
               "end_date" => "2022-08-15",
               "id" => ^lease_id,
               "mileage_limit" => 12000,
               "monthly_payment" => 600,
               "start_date" => "2022-02-15"
             } = json_response(conn, 200)
    end

    test "returns 422 on invalid lease id format", %{conn: conn} do
      not_an_uuid = "JESSE VENTURA"

      # Get lease by ID declared above
      conn = get(conn, "/api/leases/#{not_an_uuid}")

      # Assert that the retrieved lease matches that of fields declared
      assert %{"error" => "The string JESSE VENTURA is not an UUID"} = json_response(conn, 422)
    end

    test "returns 404 on non-existing lease", %{conn: conn} do
      random_uuid = Ecto.UUID.generate()

      # Get lease by ID declared above
      conn = get(conn, "/api/leases/#{random_uuid}")

      # Assert that the retrieved lease matches that of fields declared
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end
  end

  describe "PUT api/leases/:id" do
    test "successfully updates lease on valid data", %{conn: conn} do
      # Populate DB with car, customer and lease data
      {car_id, _} = Factory.insert_car()
      {customer_id, _} = Factory.insert_customer()
      {lease_id, lease} = Factory.insert_lease(car_id, customer_id)

      # Fields to be updated
      updated_monthly_payment = 2000
      updated_current_mileage = 19500

      # Only update monthly_payment and current_mileage
      updated_lease = %{
        car_id: car_id,
        customer_id: customer_id,
        monthly_payment: updated_monthly_payment,
        current_mileage: updated_current_mileage,
        mileage_limit: lease.mileage_limit,
        start_date: lease.start_date,
        end_date: lease.end_date
      }

      # Create a new lease based on the above parameters
      conn = put(conn, "/api/leases/#{lease_id}", %{lease: updated_lease})

      # Assert that the resource was created and capture the response
      assert json_response(conn, 200)

      # Get lease by ID
      conn = get(conn, "/api/leases/#{lease_id}")

      # Assert that the retrieved lease matches that of fields declared
      assert %{
               "car" => %{
                 "fuel" => "gas",
                 "horsepower" => 203,
                 "id" => ^car_id,
                 "make" => "Toyota",
                 "mileage" => 15000,
                 "model" => "Camry",
                 "price" => "20000",
                 "year" => 2020
               },
               "current_mileage" => ^updated_current_mileage,
               "customer" => %{
                 "email" => "jane.doe@example.com",
                 "first_name" => "Jane",
                 "id" => ^customer_id,
                 "last_name" => "Doe",
                 "phone_number" => "555-4321"
               },
               "end_date" => "2022-08-15",
               "id" => ^lease_id,
               "mileage_limit" => 12000,
               "monthly_payment" => ^updated_monthly_payment,
               "start_date" => "2022-02-15"
             } = json_response(conn, 200)
    end

    test "returns 404 on non-existing lease", %{conn: conn} do
      random_uuid = Ecto.UUID.generate()

      # Get lease by ID
      conn = put(conn, "/api/leases/#{random_uuid}", %{lease: nil})

      # Assert that the retrieved lease matches that of fields declared
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end
  end

  describe "DELETE api/leases/:id" do
    test "deletes data on existing lease", %{conn: conn} do
      # Populate DB with car, customer and lease data
      {car_id, _} = Factory.insert_car()
      {customer_id, _} = Factory.insert_customer()
      {lease_id, _} = Factory.insert_lease(car_id, customer_id)

      # Assert existence of newly created lease
      conn = get(conn, "/api/leases/#{lease_id}")
      assert json_response(conn, 200)

      # Delete lease
      conn = delete(conn, "/api/leases/#{lease_id}")

      # Assert success of delete operation
      response = assert json_response(conn, 200)

      # Extract lease ID from response with slice
      id = String.slice(response, 27..62)

      # Assert that the ID conforms to UUID
      assert true == match?({:ok, _}, Ecto.UUID.dump(id))

      # Assert that the ID extracted from response matches that of our input parameter
      assert lease_id == id

      # Assert lack of existence of our newly deleted lease
      conn = get(conn, "/api/leases/#{lease_id}")
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end

    test "returns 422 on invalid lease id format", %{conn: conn} do
      not_an_uuid = "JESSE VENTURA"

      # Get lease by ID
      conn = delete(conn, "/api/leases/#{not_an_uuid}")

      # Assert that the retrieved lease matches that of fields declared
      assert %{"error" => "The string JESSE VENTURA is not an UUID"} = json_response(conn, 422)
    end

    test "returns 404 on non-existing lease", %{conn: conn} do
      random_uuid = Ecto.UUID.generate()

      # Get lease by ID
      conn = delete(conn, "/api/leases/#{random_uuid}")

      # Assert that the retrieved lease matches that of fields declared
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end
  end
end
