defmodule Facts do
    alias Facts.Event
    alias Facts.Player

    def input(%Event{} = event) do
        IO.puts "got event #{Kernel.inspect(event)}"
        {player_result, player_data} = Player.feed(event)
        IO.puts "Feed summary"
        IO.puts Kernel.inspect(player_result)
        IO.puts Kernel.inspect(player_data)
        IO.puts "End feed summary"

        
    end
end
