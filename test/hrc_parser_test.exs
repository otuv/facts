defmodule HRCTest do
  use ExUnit.Case

  alias Facts.HRC

  test "parse create player" do
    data = HRC.parse("create player Adam")
    assert is_struct(data)
    assert data.predicate == :create
    assert data.subject == :player
    assert data.id == "Adam"
    assert data.details == %{}
  end

  test "parse create deck" do
    data = HRC.parse("create deck Rush with player_id adam")
    assert is_struct(data)
    assert data.predicate == :create
    assert data.subject == :deck
    assert data.id == "Rush"
    assert data.details == %{player_id: "adam"}
  end

  test "parse create game" do
    data = HRC.parse("create game with player_id adam")
    assert is_struct(data)
    assert data.predicate == :create
    assert data.subject == :game
    assert data.id == nil
    assert data.details == %{player_id: "adam"}
  end

  test "parse append deck" do
    data = HRC.parse("append deck rush with theme trolls and color green")
    assert is_struct(data)
    assert data.predicate == :append
    assert data.subject == :deck
    assert data.id == "rush"
    assert data.details == %{theme: "trolls", color: "green"}
  end

  test "parse read deck" do
    data = HRC.parse("read deck rush")
    assert is_struct(data)
    assert data.predicate == :read
    assert data.subject == :deck
    assert data.id == "rush"
    assert data.details == %{}
  end

end
