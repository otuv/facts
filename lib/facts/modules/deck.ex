defmodule Facts.Deck do

  alias Facts.Id
  alias Facts.Data
  alias Facts.Event

  @spec feed(any) :: [
          {:created, <<_::64, _::_*8>>}
          | {:deleted, binary}
          | {:read, <<_::32, _::_*8>>}
          | {:updated, <<_::64, _::_*8>>}
        ]
  def feed(%Event{id: event_id, tags: [:create, :deck], data: %{name: name, owner_id: owner_id}}) do
      deck_id = Id.hrid name
      :ok = create_deck event_id, deck_id
      :ok = add_fact_name event_id, deck_id, name
      :ok = add_fact_owner_id event_id, deck_id, owner_id
      [created: deck_id <> ", owner id: " <> owner_id]
  end

  def feed(%Event{id: _event_id, tags: [:read, :deck], data: %{id: deck_id}}) do
      facts = read_facts(deck_id)
      |> Enum.map(fn f -> parse_fact(f) end)
      |> Enum.join(", ")

      [read: "#{deck_id} :: " <> facts]
  end

  def feed(%Event{id: event_id, tags: [:update, :deck], data: %{id: deck_id, name: name}}) do
      :ok = add_fact_name event_id, deck_id, name

      [updated: "#{deck_id} :: name -> #{name}"]
  end

  def feed(%Event{id: event_id, tags: [:delete, :deck], data: %{id: deck_id}}) do
      :ok = delete_deck event_id, deck_id
      [deleted: deck_id]
  end

  def feed(%Event{id: event_id, tags: tags, data: _data} = e) do
    case Enum.any?(tags, fn t -> t == :deck end) do
        true  ->
            IO.inspect(e, label: "Failing event")
            [failure: event_id]
        false ->
            [failure: event_id]
    end
  end

  def feed(_) do
      []
  end


  def create_deck(origin, deck_id) do
      case deck_exists?(deck_id) do
          true -> {:error, :already_exist}
          false -> create_deck_file(origin, deck_id)
      end
  end


  defp deck_exists?(deck_id) do
      File.exists?(Data.facts_file_path(__ENV__.module, deck_id))
  end


  defp create_deck_file(origin, deck_id) do
      add_fact(origin, deck_id, :created)
  end


  defp add_fact_name(origin, deck_id, name) when is_bitstring(name) do
      add_fact(origin, deck_id, %{name: name})
  end

  defp add_fact_owner_id(origin, deck_id, owner_id) when is_bitstring(owner_id) do
      add_fact(origin, deck_id, %{owner_id: owner_id})
  end


  def delete_deck(origin, deck_id) do
      add_fact(origin, deck_id, :deleted)
  end


  defp add_fact(origin, deck_id, data) do
      Data.add_fact(__ENV__.module, deck_id, origin, data)
  end


  defp read_facts(deck_id) do
      Data.get_facts(__ENV__.module, deck_id)
  end


  defp parse_fact({_origin, _timestamp, %{name: name}}) do
      "name: #{name}"
  end

  defp parse_fact({_origin, _timestamp, %{owner_id: owner_id}}) do
      "owner_id: #{owner_id}"
  end

  defp parse_fact({_origin, timestamp, :created}) do
      timestamp
      |> DateTime.from_unix!(:millisecond)
      |> DateTime.to_iso8601()
      |> (fn ts -> "created " <> ts end).()
  end
end
