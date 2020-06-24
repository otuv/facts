defmodule CliTest do
  use ExUnit.Case

  import Facts.CLI, only: [parse: 1, process: 1]

  alias Facts.TestUtil
  alias Facts.Id

  test "parse" do
    assert [{:help, true}] == parse(["-h", ""])
    assert [{:create, "player"}, {:name, "Parse Player"}] == parse(["-c", "player", "--name", "Parse Player"])
    assert [{:delete, "player"}, {:id, "Delete Player"}] == parse(["-d", "player", "--id", "Delete Player"])
  end

  test "help" do
    help = process [{:help, true}]
    assert is_bitstring help
    assert String.contains?(help, "-h")
    assert String.contains?(help, "-c")
    assert String.contains?(help, "create")
    assert String.contains?(help, "--name")
    assert String.contains?(String.downcase(help), "available commands")
    assert !String.contains?(String.downcase(help), "no such command")
  end

  test "create player" do
    player_name = "Create Player CLI"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    assert "created: #{player_id}" == process [{:create, "player"}, {:name, player_name}]
    TestUtil.wipe_facts("player", player_id)
  end

  test "read player" do
    player_name = "Read Player CLI"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    process [{:create, "player"}, {:name, player_name}]
    display = process [{:read, "player"}, {:id, player_id}]
    display_chunks = String.split(display, " ")
    assert "read:" == Enum.at(display_chunks, 0)
    assert player_id == Enum.at(display_chunks, 1)
    assert player_name == Enum.join(Enum.take(display_chunks, -3), " ")
    TestUtil.wipe_facts("player", player_id)
  end

  test "update player" do
    player_name = "Create Player CLI"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    process [{:create, "player"}, {:name, player_name}]
    new_player_name = "Updated Player CLI"
    assert "updated: #{player_id} :: name -> #{new_player_name}" == process [{:update, "player"}, {:id, player_id}, {:name, new_player_name}]
    TestUtil.wipe_facts("player", player_id)
  end

  test "delete player" do
    player_name = "Create Player CLI"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    process [{:create, "player"}, {:name, player_name}]
    assert "deleted: #{player_id}" == process [{:delete, "player"}, {:id, player_id}]
    TestUtil.wipe_facts("player", player_id)
  end


  test "create deck" do
    #Need a player as owner
    owner_name = "Create Deck Player CLI"
    owner_id = Id.hrid(owner_name)
    TestUtil.wipe_facts("player", owner_id)
    process [{:create, "player"}, {:name, owner_name}]

    #Create deck
    deck_name = "Create Deck CLI"
    deck_id = Id.hrid(deck_name)
    TestUtil.wipe_facts("deck", deck_id)
    assert "created: #{deck_id}, owner: #{owner_id}" == process [{:create, "deck"}, {:name, deck_name}, {:owner, owner_id}]

    #Cleanup
    TestUtil.wipe_facts("deck", deck_id)
    TestUtil.wipe_facts("player", owner_id)
  end
end
