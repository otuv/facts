defmodule Facts do
    alias Facts.Event
    alias Facts.Player
    alias Facts.Deck

    def input(%Event{} = event) do
        [
            Player.feed(event),
            Deck.feed(event),
        ]
        |> Enum.filter(fn changes -> Enum.count(changes) > 0 end)
    end
end
