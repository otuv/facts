defmodule Facts.HRC do
  defstruct predicate: nil, subject: nil, details: %{}

  alias Facts.HRC

  def parse(input) do
    input
    |> String.split()
    |> (fn bits -> {bits, %HRC{}} end).()
    |> parse_predicate()
    |> parse_subject()
    |> parse_id()
    |> parse_details()
  end


  defp parse_predicate({[predicate|remaining], %{} = acc}) do
    {remaining, Map.put(acc, :predicate, String.to_atom(predicate))}
  end


  defp parse_subject({[subject|remaining], %{} = acc}) do
    {remaining, Map.put(acc, :subject, String.to_atom(subject))}
  end


  defp parse_id({["with"|_remaining] = data_with_no_id, %{} = acc}) do
    {data_with_no_id, acc}
  end

  defp parse_id({[id|remaining], %{} = acc}) do
    {remaining, Map.put(acc, :details, %{id: id})}
  end


  defp parse_details({[], %{} = acc}) do
    acc
  end

  defp parse_details({["with"|bits], %{} = acc}) do
    bits
    |> Enum.chunk_by(fn b -> "and" == b end)
    |> Enum.reduce(acc, fn kv, acc -> merge_kv(kv, acc) end)
  end


  defp merge_kv(["and"], acc) do
    acc
  end

  defp merge_kv([k, v], %{details: details} = acc) do
    Map.put(acc, :details, Map.put(details, String.to_atom(k), "#{v}"))
  end
end
