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


  test "create player hrc" do
    player_name = "Adam"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    assert "created: #{player_id}" == process [{:hrc, "create player Adam"}]
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


  test "read player hrc" do
    player_name = "Bertil"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    process [{:hrc, "create player Bertil"}]
    display = process [{:hrc, "read player bertil"}]
    display_chunks = String.split(display, " ")
    assert "read:" == Enum.at(display_chunks, 0)
    assert player_id == Enum.at(display_chunks, 1)
    assert player_name == Enum.join(Enum.take(display_chunks, -1), " ")
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
    #Need a player as player
    player_name = "Create Deck Player CLI"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    process [{:create, "player"}, {:name, player_name}]

    #Create deck
    deck_name = "Create Deck CLI"
    deck_id = Id.hrid(deck_name)
    TestUtil.wipe_facts("deck", deck_id)
    assert "created: #{deck_id}" == process [{:create, "deck"}, {:name, deck_name}, {:playerid, player_id}]

    #Cleanup
    TestUtil.wipe_facts("deck", deck_id)
    TestUtil.wipe_facts("player", player_id)
  end


  test "create deck hrc" do
    #Need a player as player
    player_name = "Ceasar"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    process [{:hrc, "create player #{player_name}"}]

    #Create deck
    deck_name = "Alpha"
    deck_id = Id.hrid(deck_name)
    TestUtil.wipe_facts("deck", deck_id)
    assert "created: #{deck_id}" == process [{:hrc, "create deck #{deck_name} with player_id #{player_id}"}]

    #Cleanup
    TestUtil.wipe_facts("deck", deck_id)
    TestUtil.wipe_facts("player", player_id)
  end


  test "create game" do
    #Need a player as player and player
    player_name = "Create Game Player CLI"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    process [{:create, "player"}, {:name, player_name}]

    #Need as participating deck
    deck_name = "Create Game Decj CLI"
    deck_id = Id.hrid(deck_name)
    TestUtil.wipe_facts("deck", deck_id)
    result = process [{:create, "game"}, {:playerid, player_id}]
    game_id = result
      |> String.replace(",", "")
      |> String.split(" ")
      |> Enum.at(1)

    assert "created: #{game_id}" == result

    #Cleanup
    TestUtil.wipe_facts("deck", deck_id)
    TestUtil.wipe_facts("player", player_id)
    TestUtil.wipe_facts("game", game_id)
  end


  test "create, append and read game hrc" do
    #Need a player as player
    player_name = "David"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    process [{:hrc, "create player #{player_name}"}]

    #Create game
    ["created:", game_id] = process([{:hrc, "create game with player_id #{player_id}"}]) |> String.split()
    assert is_bitstring(game_id)

    #Create deck
    deck_name = "Bravo"
    deck_id = Id.hrid(deck_name)
    TestUtil.wipe_facts("deck", deck_id)
    assert "created: #{deck_id}" == process [{:hrc, "create deck #{deck_name} with player_id #{player_id}"}]

    assert "appended: #{game_id}" == process [{:hrc, "append game #{game_id} with player_id #{player_id} and deck_id #{deck_id} and place 1"}]
    assert ["read:", ^game_id, "::", "created", creation_timestamp, "-", "player_id:", ^player_id, "-", "result:", ^player_id, ^deck_id, "1"] = process([{:hrc, "read game #{game_id}"}]) |> String.split()

    #Cleanup
    TestUtil.wipe_facts("deck", deck_id)
    TestUtil.wipe_facts("player", player_id)
    TestUtil.wipe_facts("game", game_id)
  end
end
