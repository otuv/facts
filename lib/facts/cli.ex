defmodule Facts.CLI do

  @switches [help: :boolean]
  @aliases [h: :help]

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

    result = OptionParser.parse(args, opts)

    case result do
      {[help: true], _, _} -> :help
      _ -> :no_such_command
    end
  end

  def process(:help) do
    help_text = """
    Available commands:
    --help / -h : Display help
    """
    IO.puts help_text
    help_text
  end
end
