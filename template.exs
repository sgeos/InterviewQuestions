#!/usr/bin/env elixir

# USAGE:
# chmod +x template.exs
# ./template.exs

# PROBLEM:
# Problem description here.

defmodule Script do
  def print_arg(input) do
    IO.puts("")
    input
    |> String.split(":")
    |> Enum.with_index(1)
    |> Enum.each(fn {v, i} -> IO.puts("  #{i}: #{v}") end)
  end

  # main program logic
  def run(input) do
    IO.puts("Input:")
    input
    |> Enum.map(&print_arg/1)
  end

  # fixed tests
  def test() do
    IO.puts("--- USAGE ---")
    main(["help"])
    IO.puts("")
    IO.puts("--- TEST ---")
    main(["apple:banana:cat:...", "dog"])
  end

  # program usage
  def usage() do
    IO.puts("Usage:")
    IO.puts("  #{:escript.script_name()} INPUT [INPUT ...]")
    IO.puts("  #{:escript.script_name()} help")
    IO.puts("  #{:escript.script_name()} test")
    IO.puts("")
    IO.puts("Example:")
    IO.puts("  #{:escript.script_name()} INPUT")
  end

  # now takes command line arguments
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

# fixed input
Script.main(["test"])

# command line input
#Script.main(System.argv)

