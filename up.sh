#!/bin/sh

# Exits immediately if a command exits with a non-zero status
set -e

# Build psql database based on local Dockerfile
docker build -t car_leasing_db -f dockerfiles/db/Dockerfile .

# Run database container on port 5432
docker run --name car_leasing_db -p 5432:5432 -d car_leasing_db

# Install dependencies
mix deps.get

# Run the migrations scripts
mix ecto.migrate

# Run tests and output test coverage report
mix test --cover

# Start HTTP sever
mix phx.server
