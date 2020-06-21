defmodule Facts do
    alias Facts.Event
    alias Facts.Player

    def input(%Event{} = event) do
        [Player.feed(event)]
        |> Enum.filter(fn changes -> Enum.count(changes) > 0 end)
    end
end
