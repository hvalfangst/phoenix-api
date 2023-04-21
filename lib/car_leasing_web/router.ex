defmodule CarLeasingWeb.Router do
  use CarLeasingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CarLeasingWeb do
    pipe_through :api

    get "/cars", CarController, :index
    post "/cars", CarController, :create
    get "/cars/:id", CarController, :show
    put "/cars/:id", CarController, :update
    delete "/cars/:id", CarController, :delete

    get "/customers", CustomerController, :index
    post "/customers", CustomerController, :create
    get "/customers/:id", CustomerController, :show
    put "/customers/:id", CustomerController, :update
    delete "/customers/:id", CustomerController, :delete

    get "/leases", LeaseController, :index
    post "/leases", LeaseController, :create
    get "/leases/:id", LeaseController, :show
    put "/leases/:id", LeaseController, :update
    delete "/leases/:id", LeaseController, :delete
  end
end
