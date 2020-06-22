defmodule Facts.Player do

    alias Facts.Id
    alias Facts.Data
    alias Facts.Event

    def feed(%Event{id: event_id, tags: [:new, :player], data: %{name: name}}) do
        player_id = Id.hrid name
        :ok = new_player event_id, player_id
        :ok = add_fact_name event_id, player_id, name
        [created: player_id]
    end

    def feed(%Event{id: event_id, tags: [:delete, :player], data: %{id: player_id}}) do
        :ok = delete_player event_id, player_id
        [deleted: player_id]
    end

    def feed(_) do
        []
    end


    def new_player(origin, player_id) do
        case player_exists?(player_id) do
            true -> {:error, :already_exist}
            false -> create_player_file(origin, player_id)
        end
    end

    defp player_exists?(player_id) do
        File.exists?(Data.facts_file_path(__ENV__.module, player_id))
    end

    defp create_player_file(origin, player_id) do
        Data.add_fact(__ENV__.module, player_id, origin, :created)
    end

    defp add_fact_name(origin, player_id, name) when is_bitstring(name) do
        Data.add_fact(__ENV__.module, player_id, origin, %{name: name})
    end

    def delete_player(origin, player_id) do
        Data.add_fact(__ENV__.module, player_id, origin, :deleted)
    end
end
