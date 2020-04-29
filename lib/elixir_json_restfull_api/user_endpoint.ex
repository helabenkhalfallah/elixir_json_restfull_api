defmodule ElixirJsonRestfullApi.UserEndpoint do
  @moduledoc """
  User Model :
  ```
    {
      "username": "helabenkhalfallah",
      "password": "XXX",
      "lastName": "ben khalfallah",
      "firstName": "hela",
      "email": "helabenkhalfallah@hotmail.fr",
    }
  ```

  User endpoints :
  - /users : get all users (GET)
  - /user-by-email : find user by email (POST)
  - /user-by-user-name : find user by username (POST)
  - /add-user : add a new user (POST)
  - /delete-user : delete an existing user (POST)
  - /update-user-email : update an existing user by email (POST)
  - /update-update-user-name : update an existing user by username (POST)

  """

  alias ElixirJsonRestfullApi.ServiceUtils, as: ServiceUtils
  alias ElixirJsonRestfullApi.UserReader, as: UserReader
  alias ElixirJsonRestfullApi.UserWriter, as: UserWriter

  @doc """
    Plug provides Plug.Router to dispatch incoming requests based on the path and method.
    When the router is called, it will invoke the :match plug, represented by a match/2function responsible
    for finding a matching route, and then forward it to the :dispatch plug which will execute the matched code.

    Mongo :
    https://hexdocs.pm/mongodb/Mongo.html#update_one/5

    Enum :
    https://hexdocs.pm/elixir/Enum.html#into/2

    Type :
    https://hexdocs.pm/elixir/typespecs.html

    Example :
    https://tomjoro.github.io/2017-02-09-ecto3-mongodb-phoenix/
  """
  use Plug.Router

  # This module is a Plug, that also implements it's own plug pipeline, below:

  # Using Plug.Logger for logging request information
  plug(Plug.Logger)

  # responsible for matching routes
  plug(:match)

  # Using Poison for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  # responsible for dispatching responses
  plug(:dispatch)

  # A simple route to test that the server is up
  # Note, all routes must return a connection as per the Plug spec.
  # Get all users
  get "/users" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, ServiceUtils.endpoint_success(UserReader.find_all_users()))
  end

  # Get user by email
  post "/user-by-email" do
    case conn.body_params do
      %{"email" => email} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          200,
          ServiceUtils.endpoint_success(UserReader.user_by_email(email))
        )

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, ServiceUtils.endpoint_error("missing_email"))
    end
  end

  # Get user by user name
  post "/user-by-user-name" do
    case conn.body_params do
      %{"username" => username} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          200,
          ServiceUtils.endpoint_success(UserReader.user_by_username(username))
        )

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, ServiceUtils.endpoint_error("missing_username"))
    end
  end

  # Add user
  post "/add-user" do
    {status, body} =
      case conn.body_params do
        %{"user" => user_to_add} ->
          case UserWriter.add_user(user_to_add) do
            {:ok, user} ->
              {
                200,
                ServiceUtils.endpoint_success(user)
              }

            {:error, _changeset} ->
              {
                200,
                ServiceUtils.endpoint_error("exception")
              }
          end

        _ ->
          {
            200,
            ServiceUtils.endpoint_error("missing_prams")
          }
      end

    send_resp(conn, status, body)
  end

  # Delete user
  post "/delete-user" do
    {status, body} =
      case conn.body_params do
        %{"user" => user_to_delete} ->
          case UserWriter.delete_user(user_to_delete) do
            {:ok, user} ->
              {
                200,
                ServiceUtils.endpoint_success(user)
              }

            {:error, _changeset} ->
              {
                200,
                ServiceUtils.endpoint_error("exception")
              }
          end

        _ ->
          {
            200,
            ServiceUtils.endpoint_error("missing_prams")
          }
      end

    send_resp(conn, status, body)
  end

  # Update User By Email
  post "/update-user-email" do
    {status, body} =
      case conn.body_params do
        %{"user" => user_to_update} ->
          case UserWriter.update_user_by_email(user_to_update) do
            {:ok, user} ->
              {
                200,
                ServiceUtils.endpoint_success(user)
              }

            {:error, _changeset} ->
              {
                200,
                ServiceUtils.endpoint_error("exception")
              }
          end

        _ ->
          {
            200,
            ServiceUtils.endpoint_error("missing_prams")
          }
      end

    send_resp(conn, status, body)
  end

  # Update User By User Name
  post "/update-user-name" do
    {status, body} =
      case conn.body_params do
        %{"user" => user_to_update} ->
          case UserWriter.update_user_by_username(user_to_update) do
            {:ok, user} ->
              {
                200,
                ServiceUtils.endpoint_success(user)
              }

            {:error, _changeset} ->
              {
                200,
                ServiceUtils.endpoint_error("exception")
              }
          end

        _ ->
          {
            200,
            ServiceUtils.endpoint_error("missing_prams")
          }
      end

    send_resp(conn, status, body)
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, ServiceUtils.endpoint_error("exception"))
  end
end
