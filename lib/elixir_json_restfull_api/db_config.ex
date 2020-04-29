defmodule ElixirJsonRestfullApi.DBConfig do
  @moduledoc """
    DB configuration :
    - index
    - alter
    - reset
  """

  @doc """
  List indexes
  """
  def list_indexes do
    Mongo.list_index_names(:mongo, "User")
    |> Enum.to_list()

    # |> IO.inspect()
  end
end
