alias CarLeasing.{Repo, Lease, Car, Customer}

# Execute DB inserts within a transaction
Repo.transaction(fn ->
  # Create 10 cars
  cars = [
    %Car{
      make: "Toyota",
      model: "Camry",
      year: 2020,
      price: 20000,
      mileage: 15000,
      fuel: "gas",
      horsepower: 203
    },
    %Car{
      make: "Honda",
      model: "Civic",
      year: 2021,
      price: 22000,
      mileage: 10000,
      fuel: "gas",
      horsepower: 180
    },
    %Car{
      make: "Ford",
      model: "Mustang",
      year: 2019,
      price: 35000,
      mileage: 20000,
      fuel: "gas",
      horsepower: 460
    },
    %Car{
      make: "Chevrolet",
      model: "Camaro",
      year: 2022,
      price: 40000,
      mileage: 5000,
      fuel: "gas",
      horsepower: 650
    },
    %Car{
      make: "BMW",
      model: "M3",
      year: 2020,
      price: 50000,
      mileage: 15000,
      fuel: "gas",
      horsepower: 473
    },
    %Car{
      make: "Audi",
      model: "A4",
      year: 2021,
      price: 45000,
      mileage: 10000,
      fuel: "gas",
      horsepower: 248
    },
    %Car{
      make: "Mercedes-Benz",
      model: "C-Class",
      year: 2019,
      price: 55000,
      mileage: 20000,
      fuel: "gas",
      horsepower: 385
    },
    %Car{
      make: "Lexus",
      model: "ES",
      year: 2022,
      price: 38000,
      mileage: 5000,
      fuel: "gas",
      horsepower: 302
    },
    %Car{
      make: "Tesla",
      model: "Model 3",
      year: 2021,
      price: 45000,
      mileage: 10000,
      fuel: "electric",
      horsepower: 450
    },
    %Car{
      make: "Porsche",
      model: "911",
      year: 2020,
      price: 110_000,
      mileage: 15000,
      fuel: "gas",
      horsepower: 443
    }
  ]

  # Insert cars into DB tables "cars"
  Enum.each(cars, fn car ->
    Repo.insert!(car)
  end)

  # Create 10 customers
  customers = [
    %Customer{
      first_name: "Jane",
      last_name: "Doe",
      email: "jane.doe@example.com",
      phone_number: "555-4321"
    },
    %Customer{
      first_name: "Bob",
      last_name: "Smith",
      email: "bob.smith@example.com",
      phone_number: "555-9876"
    },
    %Customer{
      first_name: "Alice",
      last_name: "Johnson",
      email: "alice.johnson@example.com",
      phone_number: "555-6789"
    },
    %Customer{
      first_name: "David",
      last_name: "Lee",
      email: "david.lee@example.com",
      phone_number: "555-2468"
    },
    %Customer{
      first_name: "Maria",
      last_name: "Garcia",
      email: "maria.garcia@example.com",
      phone_number: "555-1357"
    },
    %Customer{
      first_name: "Robert",
      last_name: "Nguyen",
      email: "robert.nguyen@example.com",
      phone_number: "555-8642"
    },
    %Customer{
      first_name: "Samantha",
      last_name: "Chen",
      email: "samantha.chen@example.com",
      phone_number: "555-3198"
    },
    %Customer{
      first_name: "Daniel",
      last_name: "Wang",
      email: "daniel.wang@example.com",
      phone_number: "555-6741"
    },
    %Customer{
      first_name: "Emily",
      last_name: "Zhang",
      email: "emily.zhang@example.com",
      phone_number: "555-8213"
    },
    %Customer{
      first_name: "Michael",
      last_name: "Liu",
      email: "michael.liu@example.com",
      phone_number: "555-4629"
    }
  ]

  # Insert customers into DB table "customers"
  Enum.each(customers, fn customer ->
    Repo.insert!(customer)
  end)

  # Create 5 leases between cars and customers
  leases = [
    %Lease{
      monthly_payment: 600,
      current_mileage: 8000,
      mileage_limit: 12000,
      start_date: ~D[2022-02-15],
      end_date: ~D[2022-08-15],
      car_id: 1,
      customer_id: 1
    },
    %Lease{
      monthly_payment: 550,
      current_mileage: 12000,
      mileage_limit: 15000,
      start_date: ~D[2022-03-01],
      end_date: ~D[2022-09-01],
      car_id: 2,
      customer_id: 2
    },
    %Lease{
      monthly_payment: 700,
      current_mileage: 6000,
      mileage_limit: 10000,
      start_date: ~D[2022-04-01],
      end_date: ~D[2022-10-01],
      car_id: 3,
      customer_id: 3
    },
    %Lease{
      monthly_payment: 650,
      current_mileage: 10000,
      mileage_limit: 15000,
      start_date: ~D[2022-05-15],
      end_date: ~D[2022-11-15],
      car_id: 4,
      customer_id: 4
    },
    %Lease{
      monthly_payment: 500,
      current_mileage: 5000,
      mileage_limit: 12000,
      start_date: ~D[2022-06-01],
      end_date: ~D[2022-12-01],
      car_id: 5,
      customer_id: 5
    }
  ]

  # Insert leases into DB table "leases"
  Enum.each(leases, fn lease ->
    Repo.insert!(lease)
  end)
end)
