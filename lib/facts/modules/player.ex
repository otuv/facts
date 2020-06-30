defmodule Facts.Player do

    alias Facts.Id
    alias Facts.Data
    alias Facts.Event

    def feed(%Event{id: event_id, tags: [:create, :player], data: %{id: id}}), do: feed(%Event{id: event_id, tags: [:create, :player], data: %{name: id}})
    def feed(%Event{id: event_id, tags: [:create, :player], data: %{name: name}}) do
        player_id = Id.hrid name
        :ok = create_player event_id, player_id
        :ok = add_fact_name event_id, player_id, name
        [created: player_id]
    end

    def feed(%Event{id: _event_id, tags: [:read, :player], data: %{id: player_id}}) do
        facts = read_facts(player_id)
        |> Enum.map(fn f -> parse_fact(f) end)
        |> Enum.join(" - ")

        [read: "#{player_id} :: " <> facts]
    end

    def feed(%Event{id: event_id, tags: [:update, :player], data: %{id: player_id, name: name}}) do
        :ok = add_fact_name event_id, player_id, name

        [updated: "#{player_id} :: name -> #{name}"]
    end

    def feed(%Event{id: event_id, tags: [:delete, :player], data: %{id: player_id}}) do
        :ok = delete_player event_id, player_id
        [deleted: player_id]
    end

    def feed(_) do
        []
    end


    def create_player(origin, player_id) do
        case player_exists?(player_id) do
            true -> {:error, :already_exist}
            false -> create_player_file(origin, player_id)
        end
    end


    defp player_exists?(player_id) do
        File.exists?(Data.facts_file_path(__ENV__.module, player_id))
    end


    defp create_player_file(origin, player_id) do
        add_fact(origin, player_id, :created)
    end


    defp add_fact_name(origin, player_id, name) when is_bitstring(name) do
        add_fact(origin, player_id, %{name: name})
    end


    def delete_player(origin, player_id) do
        add_fact(origin, player_id, :deleted)
    end


    defp add_fact(origin, player_id, data) do
        Data.add_fact(__ENV__.module, player_id, origin, data)
    end


    defp read_facts(player_id) do
        Data.get_facts(__ENV__.module, player_id)
    end


    defp parse_fact({_origin, _timestamp, %{name: name}}) do
        "name: #{name}"
    end

    defp parse_fact({_origin, timestamp, :created}) do
        timestamp
        |> DateTime.from_unix!(:millisecond)
        |> DateTime.to_iso8601()
        |> (fn ts -> "created " <> ts end).()
    end
end
