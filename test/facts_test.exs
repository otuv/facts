defmodule FactsTest do
  use ExUnit.Case
  doctest Facts

  test "greets the world" do
    assert Facts.hello() == :world
  end
end
