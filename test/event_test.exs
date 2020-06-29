defmodule EventTest do
    use ExUnit.Case

    alias Facts.Event
    alias Facts.HRC

    test "new event" do
        tags = [:create, :test]
        data = %{data: "testing"}
        assert %Event{id: _guid, tags: tags, data: data} = Event.new(tags, data)
    end

    test "new event hrc" do
        hrc = %HRC{predicate: :create, subject: :deck, details: %{name: "Name"}}
        assert %Event{id: _guid, tags: {:create, :deck}, data: %{name: "Name"}} = Event.new(hrc)
        hrc = %HRC{subject: :deck, details: %{name: "Name"}}
        assert %Event{id: _guid, tags: {:deck}, data: %{name: "Name"}} = Event.new(hrc)
        hrc = %HRC{predicate: :create, details: %{name: "Name"}}
        assert %Event{id: _guid, tags: {:create}, data: %{name: "Name"}} = Event.new(hrc)
        hrc = %HRC{details: %{name: "Name"}}
        assert %Event{id: _guid, tags: {}, data: %{name: "Name"}} = Event.new(hrc)
    end
end
