#!/bin/sh

# Check if the container exists
if docker ps -a | grep -q car_leasing_db; then
    # Stop the container if it's running
    if docker ps | grep -q car_leasing_db; then
        docker stop car_leasing_db > /dev/null 2>&1
    fi

    # Remove the container
    docker rm car_leasing_db > /dev/null 2>&1

    echo "Container car_leasing_db has been removed"
else
    echo "Container car_leasing_db does not exist"
fi