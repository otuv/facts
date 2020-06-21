defmodule DataTest do
    use ExUnit.Case

    alias Facts.Data
    alias Facts.TestUtil

    test "facts path" do
        f_path = File.cwd! <> "/data/facts/f.facts"
        assert f_path == Data.facts_file_path("f")
    end

    test "get facts" do
        id = "get_facts"
        origin = "ori_gin"
        TestUtil.wipe_facts(id)
        Data.add_fact(id, origin, :created)
        Data.add_fact(id, origin, %{name: "Get facts"})
        Data.add_fact(id, origin, %{stuff: "Things"})
        
        facts = Data.get_facts id
        assert 3 == Enum.count facts
        TestUtil.wipe_facts(id)
    end
end