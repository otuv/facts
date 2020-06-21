defmodule IdTest do
    use ExUnit.Case

    import Facts.Id, only: [guid: 0]

    test "guid" do
        id = guid()
        IO.puts id
        assert 15 == String.length(id)
    end
end