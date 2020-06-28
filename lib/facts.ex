defmodule Facts do
    alias Facts.Event
    alias Facts.Player
    alias Facts.Deck
    alias Facts.Game

    def input(%Event{} = event) do
        [
            Player.feed(event),
            Deck.feed(event),
            Game.feed(event),
        ]
        |> Enum.filter(fn changes -> Enum.count(changes) > 0 end)
    end
end
