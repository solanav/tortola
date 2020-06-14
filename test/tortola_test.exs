defmodule TortolaTest do
  use ExUnit.Case
  doctest Tortola

  test "greets the world" do
    assert Tortola.hello() == :world
  end
end
