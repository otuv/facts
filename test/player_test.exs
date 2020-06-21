defmodule PlayerTest do
    use ExUnit.Case

    import Facts.Player, only: [feed: 1, new_player: 2, delete_player: 2]

    alias Facts.TestUtil
    alias Facts.Data
    alias Facts.Id
    alias Facts.Event

    test "new player" do
        player_name = "Ola"
        player_id = Id.hrid(player_name)
        TestUtil.wipe_facts(player_id)
        facts_path = Data.facts_file_path(player_id)
        event = Event.new([:new, :player], %{name: player_name})
        assert {:ok, [{:created, player_id}]} == feed event
        assert File.exists?(facts_path)
        TestUtil.wipe_facts(player_id)
    end

    test "CRD" do
        origin = "test_player_CRD"
        player_id = "player_x"
        assert :ok == new_player(origin, player_id)
        assert {:error, :already_exist} == new_player(origin, player_id)
        assert :ok == delete_player(origin, player_id)
        TestUtil.wipe_facts(player_id)
    end

    test "basic feed" do
        event = {{123},{:show, :game},%{id: "abc_efg"}}
        assert {:ok, 0} = feed event
    end
  end
