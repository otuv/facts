defmodule CliTest do
  use ExUnit.Case

  import Facts.CLI, only: [parse: 1, process: 1]

  alias Facts.TestUtil
  alias Facts.Id

  test "parse" do
    assert [{:help, true}] == parse(["-h", ""])
    assert [{:new, "player"}, {:name, "Parse Player"}] == parse(["-n", "player", "--name", "Parse Player"])
    assert [{:delete, "player"}, {:id, "Delete Player"}] == parse(["-d", "player", "--id", "Delete Player"])
  end

  test "help" do
    help = process [{:help, true}]
    assert is_bitstring help
    assert String.contains?(help, "-h")
    assert String.contains?(help, "-n")
    assert String.contains?(help, "new")
    assert String.contains?(help, "--name")
    assert String.contains?(String.downcase(help), "available commands")
    assert !String.contains?(String.downcase(help), "no such command")
  end

  test "new player" do
    player_name = "New Player CLI"
    player_id = Id.hrid(player_name)
    TestUtil.wipe_facts("player", player_id)
    assert "created: #{player_id}" == process [{:new, "player"}, {:name, player_name}]
    TestUtil.wipe_facts("player", player_id)
  end
end
