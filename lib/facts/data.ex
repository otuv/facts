defmodule Facts.Data do
  alias Facts.Data

  def data_path(), do: File.cwd! <> "/data"
  def facts_path(), do: data_path() <> "/facts"

  def facts_file_path(id) do
    facts_path() <> "/" <> id <> ".facts"
  end

  def fact(origin, data) do
    {origin, data}
  end

  def add_fact(id, origin, data) do
    bin = 
      fact(origin, data)
      |> :erlang.term_to_binary()
    line = bin <> "\n"
    File.write(Data.facts_file_path(id), line, [:append])
  end

  def get_facts(id) do
    File.stream!(Data.facts_file_path(id))
    |> Enum.map(fn(b)-> :erlang.binary_to_term(b) end)
  end
end
  