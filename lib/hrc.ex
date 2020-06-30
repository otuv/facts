defmodule Facts.HRC do
  defstruct predicate: nil, subject: nil, id: nil, details: %{}

  alias Facts.HRC

  def parse(input) do
    input
    |> String.split()
    |> (fn bits -> {bits, %HRC{}} end).()
    |> parse_predicate()
    |> parse_subject()
    |> parse_details()
  end


  defp parse_predicate({[predicate|remaining], %{} = acc}) do
    {remaining, Map.put(acc, :predicate, String.to_atom(predicate))}
  end


  defp parse_subject({[subject|remaining], %{} = acc}) do
    {remaining, Map.put(acc, :subject, String.to_atom(subject))}
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
