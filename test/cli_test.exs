defmodule CliTest do
  use ExUnit.Case

  import Facts.CLI, only: [parse: 1, process: 1]

  test "parse" do
    assert [{:help, true}] == parse(["-h", ""])
    assert [{:new, "player"}, {:name, "testplayer"}] == parse(["-n", "player", "--name", "testplayer"])
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
    {:ok, id} = process [{:new, "player"}, {:name, "newplayer"}]
    assert is_bitstring id
  end
end
