defmodule ElixirJsonRestfullApi.UserReader do
  @moduledoc """
    User queries :
      - /users : get all users (GET)
      - /user-by-email : find user by email (POST)
      - /user-by-user-name : find user by username (POST)
  """

  @doc """
  Find all users from mongo db
  """
  @spec find_all_users() :: list
  def find_all_users do
    # Gets All Users from Mongo
    cursor = Mongo.find(:mongo, "User", %{})

    # Json encode result
    cursor
    |> Enum.to_list()
    |> handle_users_db_status()
  end

  @doc """
  Handle fetched database users status
  """
  @spec handle_users_db_status(list) :: list
  def handle_users_db_status(users) do
    if Enum.empty?(users) do
      []
    else
      users
    end
  end

  @doc """
  Find user by mail
  """
  @spec user_by_email(%{}) :: %{}
  def user_by_email(email) do
    Mongo.find_one(:mongo, "User", %{email: email})
  end

  @doc """
  Find user by username
  """
  @spec user_by_username(%{}) :: %{}
  def user_by_username(username) do
    Mongo.find_one(:mongo, "User", %{username: username})
  end
end
