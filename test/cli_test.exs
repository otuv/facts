defmodule CliTest do
  use ExUnit.Case

  import Facts.CLI, only: [parse: 1, process: 1]

  test "parse" do
    assert :help == parse(["-h", ""])
  end

  test "process" do
    help = process(:help)
    assert is_bitstring help
    assert String.contains?(help, "-h")
    assert String.contains?(String.downcase(help), "available commands")
  end
end
