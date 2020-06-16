defmodule Facts.CLI do

  @switches [
    help: :boolean,
    new: :string,
    name: :string,
  ]
  @aliases [
    h: :help,
    n: :new,
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
    help_text = """
    Available commands:
    --help/-h : Display help
    """
    IO.puts help_text
    help_text
  end

  def process(_) do
    help_text = """
    No such command. Use --help/-h to display available commands.
    """
    IO.puts help_text
    help_text
  end
end
