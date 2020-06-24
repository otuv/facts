defmodule DataTest do
    use ExUnit.Case

    alias Facts.Data
    alias Facts.TestUtil

    test "facts path" do
        f_path = File.cwd! <> "/data/facts/datatest/f.facts"
        assert f_path == Data.facts_file_path(__ENV__.module, "f")
    end

    test "get facts" do
        id = "get_facts"
        origin = "ori_gin"
        TestUtil.wipe_facts(__ENV__.module, id)
        Data.add_fact(__ENV__.module, id, origin, :created)
        Data.add_fact(__ENV__.module, id, origin, %{name: "Get facts"})
        Data.add_fact(__ENV__.module, id, origin, %{stuff: "Things"})

        facts = Data.get_facts __ENV__.module, id
        assert 3 == Enum.count facts
        TestUtil.wipe_facts(__ENV__.module, id)
    end

    test "facts" do
        origin = "ori_ghin"
        data = %{name: "Fact"}
        prior = DateTime.utc_now()
            |> DateTime.to_unix(:millisecond)
        {^origin, timestamp, ^data} = Data.fact(origin, data)
        assert prior <= timestamp
    end
end
