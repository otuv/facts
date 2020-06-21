defmodule Facts.TestUtil do
    import Facts.Data, only: [facts_file_path: 1]

    def wipe_facts(id) do
        File.rm facts_file_path(id)
    end
end