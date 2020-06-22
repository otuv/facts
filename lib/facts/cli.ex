defmodule Facts.CLI do

  alias Facts.Event

  @switches [
    help: :boolean,
    new: :string,
    delete: :string,
    name: :string,
  ]
  @aliases [
    h: :help,
    n: :new,
    d: :delete,
  ]

  def main(args) do
    args
    |> parse
    |> process
  end


  def parse(args) do
    opts = [
      switches: @switches,
      aliases: @aliases
    ]

    IO.puts(Kernel.inspect(args))

    {result, _, _} = OptionParser.parse(args, opts)
    result
  end


  def process([{:help, true}]) do
    display_switches = @switches
    |> Enum.map(fn({command, type})-> {command, type, Enum.find(@aliases, {nil, nil}, fn {_alis, full} -> full == command end)} end)
    |> Enum.map(fn({command, type, {alis, _full}})-> {command, type, (if (alis != nil), do: "(-#{alis})", else: "")} end)
    |> Enum.map(fn({command, type, alis_display})-> {"--#{Atom.to_string(command)}", type, alis_display} end)
    |> Enum.map(fn({command_display, type, alis_display})-> "#{command_display} #{alis_display}  #{Kernel.inspect(type)}" end)

    help_text = """
    Available commands:
    #{Enum.join(display_switches, "\n")}
    """
    IO.puts help_text
    help_text
  end

  def process([{:new, "player"}, {:name, name}]) do
    Event.new([:new, :player], %{name: name})
    |> Facts.input()
    |> (fn [[created: id]] -> {:ok, id} end).()
    |> IO.inspect()
  end

  def process([{:delete, "player"}, {:id, id}]) do
    Event.new([:delete, :player], %{id: id})
    |> Facts.input()
    |> (fn [[deleted: id]] -> {:ok, id} end).()
    |> IO.inspect()
  end

  def process(_) do
    help_text = """
    No such command. Use --help/-h to display available commands.
    """
    IO.puts help_text
    help_text
  end
end
