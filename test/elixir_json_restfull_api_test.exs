defmodule ElixirJsonRestfullApiTest do
  use ExUnit.Case
  doctest ElixirJsonRestfullApi

  test "greets the world" do
    assert ElixirJsonRestfullApi.hello() == :world
  end
end
