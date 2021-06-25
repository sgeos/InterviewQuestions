#!/usr/bin/env elixir

# PROBLEM:
# ...

defmodule Script do
  # main program logic
  def run(args) do
    IO.inspect(args)
  end

  # fixed test cases
  def test() do
    IO.puts("--- TESTS ---")
    main([""])
  end

  # program usage
  def usage() do
    IO.puts("Usage:")
    IO.puts("  #{:escript.script_name()} INPUT [INPUT ...]")
    IO.puts("  #{:escript.script_name()} help")
    IO.puts("  #{:escript.script_name()} test")
    IO.puts("")
    IO.puts("Examples:")
    IO.puts("  #{:escript.script_name()} input")
  end

  # entry point
  def main(args) do
    args = args |> Enum.map(&String.downcase/1)
    cond do
      Enum.member?(args, "test") -> test()
      Enum.member?(args, "help") -> usage()
      0 == length(args) -> usage()
      true -> run(args)
    end
  end
end

# call with fixed input
Script.main(["test"])

# call with command line arguments
#Script.main(System.argv)

