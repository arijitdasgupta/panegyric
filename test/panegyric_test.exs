defmodule PanegyricTest do
  use ExUnit.Case
  doctest Panegyric

  test "greets the world" do
    assert Panegyric.hello() == :world
  end
end
