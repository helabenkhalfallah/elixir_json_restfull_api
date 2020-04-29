defmodule ElixirJsonRestfullApi.ServiceUtils do
  @moduledoc """
  Services Utils
  """

  @doc """
  Extends BSON to encode Mongo DB Object Id binary type.
  Mongo object id are like : "_id": "5d658cd0de28b65b8db81606"
  """
  defimpl Poison.Encoder, for: BSON.ObjectId do
    def encode(id, options) do
      BSON.ObjectId.encode!(id)
      |> Poison.Encoder.encode(options)
    end
  end

  @doc """
  Format service success response
  """
  @spec endpoint_success(any) :: binary
  def endpoint_success(data) do
    Poison.encode!(%{
      "status" => 200,
      "data" => data
    })
  end

  @doc """
  Format service fail response
  """
  @spec endpoint_error(binary) :: binary
  def endpoint_error(error_type) do
    Poison.encode!(%{
      "status" => 200,
      "fail_reason" =>
        cond do
          error_type == 'empty' -> "Empty Data"
          error_type == 'not_found' -> "Not found"
          error_type == 'missing_email' -> "Missing email"
          error_type == 'missing_username' -> "Missing username"
          error_type == 'missing_prams' -> "Missing query params"
          error_type == 'exception' -> "An expected error was occurred"
        end
    })
  end
end
