defmodule EventTest do
    use ExUnit.Case

    alias Facts.Event

    test "new event" do
        tags = [:new, :test]
        data = %{data: "testing"}
        assert %Event{id: _guid, tags: tags, data: data} = Event.new(tags, data)
    end
end