defmodule Facts.Data do
  alias Facts.Data

  def data_path(), do: File.cwd! <> "/data"
  def facts_path(), do: data_path() <> "/facts"

  def facts_file_path(module_name, id) when is_bitstring(module_name) do
    facts_path() <> "/" <> module_name <> "/" <> id <> ".facts"
  end

  def facts_file_path(module, id) do
    facts_path() <> "/" <> convert_to_module_name(module) <> "/" <> id <> ".facts"
  end

  defp convert_to_module_name(module) do
    module
      |> Kernel.inspect()
      |> String.downcase()
      |> String.split(".")
      |> Enum.reverse()
      |> List.first()
  end

  def fact(origin, data) do
    {origin, data}
  end

  def add_fact(module, id, origin, data) do
    bin =
      fact(origin, data)
      |> :erlang.term_to_binary()
    line = bin <> "\n"
    File.write(Data.facts_file_path(module, id), line, [:append])
  end

  def get_facts(module, id) do
    File.stream!(Data.facts_file_path(module, id))
    |> Enum.map(fn(b)-> :erlang.binary_to_term(b) end)
  end
end
