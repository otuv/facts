defmodule PlayerTest do
    use ExUnit.Case

    import Facts.Player, only: [feed: 1, create_player: 2, delete_player: 2]

    alias Facts.TestUtil
    alias Facts.Data
    alias Facts.Id
    alias Facts.Event

    test "create player" do
        player_name = "Create Player"
        player_id = Id.hrid(player_name)
        TestUtil.wipe_facts("player", player_id)
        facts_path = Data.facts_file_path("player", player_id)
        event = Event.new([:create, :player], %{name: player_name})
        assert [{:created, player_id}] == feed event
        assert File.exists?(facts_path)
        TestUtil.wipe_facts("player", player_id)
    end

    test "CRD" do
        origin = "test_player_CRD"
        player_id = "player_x"
        assert :ok == create_player(origin, player_id)
        assert {:error, :already_exist} == create_player(origin, player_id)
        assert :ok == delete_player(origin, player_id)
        TestUtil.wipe_facts("player", player_id)
    end

    test "basic feed" do
        assert [] = feed Event.new([:show, :game], %{id: "abc_efg"})
    end
  end
