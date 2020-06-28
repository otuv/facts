defmodule Facts.Game do

  alias Facts.Id
  alias Facts.Data
  alias Facts.Event

  @spec feed(any) :: [
          {:created, <<_::64, _::_*8>>}
          | {:deleted, binary}
          | {:read, <<_::32, _::_*8>>}
          | {:updated, <<_::64, _::_*8>>}
        ]
  def feed(%Event{id: event_id, tags: [:create, :game], data: %{player_id: player_id}}) do
      game_id = Id.guid()
      :ok = create_game event_id, game_id
      :ok = add_fact_player_id event_id, game_id, player_id
      [created: game_id <> ", player id: " <> player_id]
  end

  def feed(%Event{id: _event_id, tags: [:read, :game], data: %{id: game_id}}) do
      facts = read_facts(game_id)
      |> Enum.map(fn f -> parse_fact(f) end)
      |> Enum.join(", ")

      [read: "#{game_id} :: " <> facts]
  end

  def feed(%Event{id: event_id, tags: [:delete, :game], data: %{id: game_id}}) do
      :ok = delete_game event_id, game_id
      [deleted: game_id]
  end

  def feed(_) do
      []
  end


  def create_game(origin, game_id) do
      case game_exists?(game_id) do
          true -> {:error, :already_exist}
          false -> create_game_file(origin, game_id)
      end
  end


  defp game_exists?(game_id) do
      File.exists?(Data.facts_file_path(__ENV__.module, game_id))
  end


  defp create_game_file(origin, game_id) do
      add_fact(origin, game_id, :created)
  end


  defp add_fact_player_id(origin, game_id, player_id) when is_bitstring(player_id) do
      add_fact(origin, game_id, %{player_id: player_id})
  end


  def delete_game(origin, game_id) do
      add_fact(origin, game_id, :deleted)
  end


  defp add_fact(origin, game_id, data) do
      Data.add_fact(__ENV__.module, game_id, origin, data)
  end


  defp read_facts(game_id) do
      Data.get_facts(__ENV__.module, game_id)
  end


  defp parse_fact({_origin, _timestamp, %{name: name}}) do
      "name: #{name}"
  end

  defp parse_fact({_origin, _timestamp, %{player_id: player_id}}) do
      "player_id: #{player_id}"
  end

  defp parse_fact({_origin, timestamp, :created}) do
      timestamp
      |> DateTime.from_unix!(:millisecond)
      |> DateTime.to_iso8601()
      |> (fn ts -> "created " <> ts end).()
  end
end
