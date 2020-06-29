defmodule HRCTest do
  use ExUnit.Case

  alias Facts.HRC

  test "parse create player" do
    data = HRC.parse("create player with name Adam")
    IO.inspect(data, label: "data")
    assert is_struct(data)
    assert data.predicate == :create
    assert data.subject == :player
    assert data.details == %{name: "Adam"}
  end

  test "parse create deck" do
    data = HRC.parse("create deck with name Rush and player_id adam")
    IO.inspect(data, label: "data")
    assert is_struct(data)
    assert data.predicate == :create
    assert data.subject == :deck
    assert data.details == %{name: "Rush", player_id: "adam"}
  end
end
