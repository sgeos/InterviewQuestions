#!/usr/bin/env elixir

# PROBLEM:
#Generates a string where consecutive elements are represented
# as a data value and count.
#  "HORSE" => "1H1O1R1S1E"
#  "ABC" => "A1B1C1"
#  "ABB" => "A1B2"
#  "CCC" => "C3"

defmodule Script do
  # core problem logic
  def encode(""), do: ""
  def encode(string) do
    string
    |> to_charlist
    |> Enum.chunk_by(&(&1))
    |> Enum.map(fn c -> String.first(to_string(c)) <> to_string(length(c)) end)
    |> Enum.join
  end

  # reusable printing function
  def print_rle(""), do: IO.puts("(empty string) => (empty string)")
  def print_rle(string) do
    result = encode(string)
    IO.puts("\"#{string}\" => \"#{result}\"")
  end

  # main program logic
  def run(args) do
    args
    |> Enum.each(&print_rle/1)
  end

  # fixed test cases
  def test() do
    IO.puts("--- USAGE ---")
    main(["help"])
    IO.puts("")
    IO.puts("--- SIMPLE TESTS ---")
    main([""])
    main(["aaa", "aba", "abc"])
    main(["AAA", "ABB", "CCC"])
    IO.puts("--- HARD TESTS ---")
    main(["1233434411111", "🗒🗒🗒🗒🗒", "    "])
  end

  # program usage
  def usage() do
    IO.puts("Usage:")
    IO.puts("  #{:escript.script_name()} INPUT [INPUT ...]")
    IO.puts("  #{:escript.script_name()} help")
    IO.puts("  #{:escript.script_name()} test")
    IO.puts("")
    IO.puts("Examples:")
    IO.puts("  #{:escript.script_name()} aaa aba abc")
    IO.puts("  #{:escript.script_name()} AAA ABB CCC")
    IO.puts("  #{:escript.script_name()} \"\"")
  end

  # entry point
  def main(args) do
    largs = args |> Enum.map(&String.downcase/1)
    cond do
      Enum.member?(largs, "test") -> test()
      Enum.member?(largs, "help") -> usage()
      0 == length(args) -> usage()
      true -> run(args)
    end
  end
end

# call with command line arguments
Script.main(System.argv)

