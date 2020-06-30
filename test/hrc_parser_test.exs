defmodule HRCTest do
  use ExUnit.Case

  alias Facts.HRC

  test "parse create player" do
    data = HRC.parse("create player with name Adam")
    assert is_struct(data)
    assert data.predicate == :create
    assert data.subject == :player
    assert data.details == %{name: "Adam"}
  end

  test "parse create deck" do
    data = HRC.parse("create deck with name Rush and player_id adam")
    assert is_struct(data)
    assert data.predicate == :create
    assert data.subject == :deck
    assert data.details == %{name: "Rush", player_id: "adam"}
  end

  test "parse create game" do
    data = HRC.parse("create game with player_id adam")
    assert is_struct(data)
    assert data.predicate == :create
    assert data.subject == :game
    assert data.details == %{player_id: "adam"}
  end

  test "parse append deck" do
    data = HRC.parse("append deck with id rush and color red")
    assert is_struct(data)
    assert data.predicate == :append
    assert data.subject == :deck
    assert data.details == %{id: "rush", color: "red" }
  end

end
