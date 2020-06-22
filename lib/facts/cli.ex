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

  def process([{:new, module_name}, {:name, name}]) do
    Event.new([:new, valid_module(module_name)], %{name: name})
    |> Facts.input()
    |> display_response()
  end

  def process([{:delete, module_name}, {:id, id}]) do
    Event.new([:delete, valid_module(module_name)], %{id: id})
    |> Facts.input()
    |> display_response()
  end

  def process(_) do
    help_text = """
    No such command. Use --help/-h to display available commands.
    """
    display_help(help_text)
  end


  defp display_help(help_text) do
    IO.puts help_text
    help_text
  end


  defp display_response([]) do
    IO.inspect("Done")
  end

  defp display_response([responses]) when is_list(responses) do
    responses
    |> Enum.map(fn {action, identifier} -> Atom.to_string(action) <> ": " <> identifier end)
    |> Enum.join(", ")
    |> IO.inspect()
  end


  defp valid_module(input_string) do
    valid_modules = %{
      "player" => :player,
    }

    case is_nil(valid_modules[input_string]) do
      false -> valid_modules[input_string]
      true ->
        help_text = """
        No such object "#{input_string}". Use --available-objects to display available objects.
        """
        display_help(help_text)
    end
  end
end
