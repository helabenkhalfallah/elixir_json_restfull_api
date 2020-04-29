defmodule ElixirJsonRestfullApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # List all child processes to be supervised

      # Start HTTP server
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: ElixirJsonRestfullApi.UserEndpoint,
        options: Application.get_env(:elixir_json_restfull_api, :endPoint)[:port]
      ),

      # Start mongo
      worker(Mongo, [
        [
          name: :mongo,
          database: Application.get_env(:elixir_json_restfull_api, :db)[:database],
          pool_size: Application.get_env(:elixir_json_restfull_api, :db)[:pool_size]
        ]
      ])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [
      strategy: :one_for_one,
      name: ElixirJsonRestfullApi.Supervisor
    ]

    # Indexes
    # ElixirJsonRestfullApi.DBConfig.list_indexes()

    Supervisor.start_link(children, opts)
  end
end
