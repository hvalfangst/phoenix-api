# Phoenix-Car-Leasing-API
Elixir REST API with Phoenix &amp; Ecto

## Requirements

* Elixir
* Docker
* Linux/Unix 

##

## Creating resources
The shell script "up.sh" creates our postgres container, runs migration scripts and serves our phoenix application.
```
sh up.sh
```


## Deleting resources
The shell script "down.sh" stops and deletes our postgres container.

```
sh down.sh
```

## Postman
A postman collection containing request examples has been included in the folder postman.

## Pipeline
An Elixir CI pipeline has been set up with a Github Actions Workflow. It spins up a postgresql container, runs our tests and outputs the the test coverage report.


