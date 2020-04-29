defmodule ElixirJsonRestfullApi.UserWriter do
  @moduledoc """
    User mutations :
      - /add-user : add a new user (POST)
      - /delete-user : delete an existing user (POST)
      - /update-user-email : update an existing user by email (POST)
      - /update-update-user-name : update an existing user by username (POST)
  """

  @doc """
  Add User
  """
  @spec add_user(%{}) :: any
  def add_user(user_to_add) do
    case Mongo.insert_one(:mongo, "User", user_to_add) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Delete User
  """
  @spec delete_user(%{}) :: any
  def delete_user(user_to_delete) do
    case Mongo.delete_one(:mongo, "User", user_to_delete) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Update user by email
  username & email are unique identifiers
  and should not been modified
  """
  @spec update_user_by_email(%{}) :: any
  def update_user_by_email(user) do
    case Mongo.update_one(
           :mongo,
           "User",
           %{"email" => user["email"]},
           %{"$set" => params_to_json(user)},
           return_document: :after
         ) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Update user by username
  username & email are unique identifiers
  and should not been modified
  """
  @spec update_user_by_username(%{}) :: any
  def update_user_by_username(user) do
    case Mongo.update_one(
           :mongo,
           "User",
           %{"username" => user["username"]},
           %{"$set" => params_to_json(user)},
           return_document: :after
         ) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Convert params object to mongo object
  """
  @spec params_to_json(%{}) :: any
  def params_to_json(params) do
    # we should keep same id
    # user can't modify username or email (unique identifiers)
    attributes =
      params
      |> Map.delete("id")
      |> Map.delete("username")
      |> Map.delete("email")

    reduced =
      Enum.into(
        attributes,
        %{},
        fn {key, value} ->
          {"#{key}", value}
        end
      )
  end
end
