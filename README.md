# Elixir JSON RESTful API (without using Phoenix)

## Create new project 

```shell script
mix new elixir_json_restfull_api --sup
```

Ensure you have supervised mode :

https://elixir-lang.org/getting-started/mix-otp/supervisor-and-application.html


## Add required dependencies 

```elixir
      {:cowboy, "~> 2.7"},
      {:poison, "~> 4.0"},
      {:plug, "~> 1.10"}
```

```shell script
mix do deps.get, deps.compile, compile
```

