defmodule Facts.TestUtil do
    alias Facts.Data

    def wipe_facts(module, id) do
        File.rm Data.facts_file_path(module, id)
    end
end
