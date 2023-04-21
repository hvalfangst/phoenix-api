defmodule CarLeasingWeb.CarControllerTest do
  use CarLeasingWeb.ConnCase

  alias CarLeasing.Car
  alias CarLeasingWeb.Factory

  describe "GET api/cars" do
    test "returns list of two cars", %{conn: conn} do
      # Insert cars to DB
      {first_car_id, _} = Factory.insert_car()
      {second_car_id, _} = Factory.insert_car(%Car{make: "Ford", model: "Mustang"})

      # Execute GET api/cars
      conn = get(conn, "/api/cars")

      # Assert that the JSON response corresponds to our newly inserted data
      assert [
               %{
                 "fuel" => "gas",
                 "horsepower" => 203,
                 "id" => ^first_car_id,
                 "make" => "Toyota",
                 "mileage" => 15000,
                 "model" => "Camry",
                 "price" => "20000",
                 "year" => 2020
               },
               %{
                 "fuel" => nil,
                 "horsepower" => nil,
                 "id" => ^second_car_id,
                 "make" => "Ford",
                 "mileage" => nil,
                 "model" => "Mustang",
                 "price" => nil,
                 "year" => nil
               }
             ] = json_response(conn, 200)
    end

    test "returns empty list on no data", %{conn: conn} do
      # Execute GET api/cars
      conn = get(conn, "/api/cars")

      # Assert that the JSON response corresponds to an empty list
      assert [] = json_response(conn, 200)
    end
  end

  describe "POST api/cars" do
    test "successfully creates new car on valid data", %{conn: conn} do
      # Request parameters
      car_params = %{
        make: "Toyota",
        model: "Camry",
        year: 2020,
        price: 20000,
        mileage: 15000,
        fuel: "gas",
        horsepower: 203
      }

      # Execute POST /api/cars with cars_params as request body
      conn = post(conn, "/api/cars", %{car: car_params})

      # Assert that the resource was created and capture the response
      response = assert json_response(conn, 201)

      # Retrieve car ID with slice
      id = String.slice(response, 36..71)

      # Assert that the ID is in fact a UUID
      assert true == match?({:ok, _}, Ecto.UUID.dump(id))

      # Get car by ID declared above
      conn = get(conn, "/api/cars/#{id}")

      # Assert that the retrieved car matches that of fields declared
      assert json_response(conn, 200)
    end

    test "returns 422 with changeset errors on invalid input", %{conn: conn} do
      illegal_value = "MOLASSES"

      car_params = %{
        make: illegal_value,
        model: illegal_value,
        year: illegal_value,
        price: illegal_value,
        mileage: illegal_value,
        fuel: illegal_value,
        horsepower: illegal_value
      }

      # Create a new car based on the above, illegal parameters
      conn = post(conn, "/api/cars", %{car: car_params})

      # Assert that the retrieved car matches that of fields declared
      assert %{
               "changeset_errors" => %{
                 "horsepower" => "is invalid",
                 "mileage" => "is invalid",
                 "price" => "is invalid",
                 "year" => "is invalid"
               }
             } = json_response(conn, 422)
    end
  end

  describe "GET api/cars/:id" do
    test "returns car on valid, existing car ID", %{conn: conn} do
      # Populate DB with car data
      {car_id, _} = Factory.insert_car()

      # Get car by ID
      conn = get(conn, "/api/cars/#{car_id}")

      # Assert that the retrieved car matches that of fields declared
      assert %{
               "fuel" => "gas",
               "horsepower" => 203,
               "id" => ^car_id,
               "make" => "Toyota",
               "mileage" => 15000,
               "model" => "Camry",
               "price" => "20000",
               "year" => 2020
             } = json_response(conn, 200)
    end

    test "returns 422 on invalid car id format", %{conn: conn} do
      not_an_uuid = "IRON PANDA"

      # Get car by ID declared above
      conn = get(conn, "/api/cars/#{not_an_uuid}")

      # Assert that the retrieved car matches that of fields declared
      assert %{"error" => "The string IRON PANDA is not an UUID"} = json_response(conn, 422)
    end

    test "returns 404 on non-existing car", %{conn: conn} do
      random_uuid = Ecto.UUID.generate()

      # Get car by ID declared above
      conn = get(conn, "/api/cars/#{random_uuid}")

      # Assert that the response corresponds to a 404 error
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end

    test "returns 404 on invalid ID format", %{conn: conn} do
      not_an_uuid = "JESSE VENTURA"

      # Get car by ID
      conn = get(conn, "/api/cars/#{not_an_uuid}")

      # Assert that response corresponds to validation error related to UUID non-conformity
      assert %{"error" => "The string JESSE VENTURA is not an UUID"} = json_response(conn, 422)
    end
  end

  describe "PUT api/cars/:id" do
    test "updates car on valid parameters", %{conn: conn} do
      # Insert car to DB
      {car_id, car} = Factory.insert_car()

      # Fields to be updated
      updated_make = "KK"
      updated_model = "Snail"
      updated_year = 1991
      updated_fuel = "molasses"

      # Struct to be passed
      updated_car = %{
        make: updated_make,
        model: updated_model,
        year: updated_year,
        fuel: updated_fuel,
        price: car.price,
        mileage: car.mileage,
        horsepower: car.horsepower
      }

      # Execute PUT api/cars
      conn = put(conn, "/api/cars/#{car_id}", %{car: updated_car})

      # Assert success of PUT
      assert json_response(conn, 200)

      # Get car by ID
      conn = get(conn, "/api/cars/#{car_id}")

      # Assert that the car is indeed updated
      assert %{
               "fuel" => ^updated_fuel,
               "horsepower" => 203,
               "id" => ^car_id,
               "make" => "KK",
               "mileage" => 15000,
               "model" => ^updated_model,
               "price" => "20000",
               "year" => ^updated_year
             } = json_response(conn, 200)
    end

    test "returns 404 on non-existing car", %{conn: conn} do
      random_uuid = Ecto.UUID.generate()

      # Get car by ID declared above
      conn = put(conn, "/api/cars/#{random_uuid}", %{car: nil})

      # Assert that the retrieved car matches that of fields declared
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end
  end

  describe "DELETE api/cars/:id" do
    test "deletes car on valid, existing ID", %{conn: conn} do
      # Insert a new car to DB
      {car_id, _} = Factory.insert_car()

      # Assert the existence of newly created car
      conn = get(conn, "/api/cars/#{car_id}")
      assert json_response(conn, 200)

      # Delete aforementioned car
      conn = delete(conn, "/api/cars/#{car_id}")

      # Assert success of delete operation
      response = assert json_response(conn, 200)

      # Extract car ID from response with slice
      id = String.slice(response, 25..60)

      # Assert that the extracted ID conforms to UUID
      assert true == match?({:ok, _}, Ecto.UUID.dump(id))

      # Assert that the two car ID matches
      assert car_id == id

      # Assert lack of existence of our newly deleted cars
      conn = get(conn, "/api/cars/#{car_id}")
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end

    test "returns 422 on invalid car ID format", %{conn: conn} do
      not_an_uuid = "DUDE"

      # Get car by ID
      conn = delete(conn, "/api/cars/#{not_an_uuid}")

      # Assert mismatch
      assert %{"error" => "The string DUDE is not an UUID"} = json_response(conn, 422)
    end

    test "returns 404 on non-existing car", %{conn: conn} do
      random_uuid = Ecto.UUID.generate()

      # Get car by ID
      conn = delete(conn, "/api/cars/#{random_uuid}")

      # Assert that the retrieved car matches that of fields declared
      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end
  end
end
