defmodule CliTest do
  use ExUnit.Case

  import Facts.CLI, only: [parse: 1, process: 1]

  test "parse" do
    assert [{:help, true}] == parse(["-h", ""])
  end

  test "process" do
    help = process [{:help, true}]
    assert is_bitstring help
    assert String.contains?(help, "-h")
    assert String.contains?(String.downcase(help), "available commands")
    assert !String.contains?(String.downcase(help), "no such command")
  end
end
