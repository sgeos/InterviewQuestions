#!/usr/bin/env elixir

# USAGE:
# chmod +x template.exs
# ./template.exs

# PROBLEM:
# Problem description here.
# This template calculates the symmetric difference of multiple input sets.

defmodule Script do
  # core problem logic
  def symmetric_difference(args) do
    args
    |> Enum.reduce(&Kernel.++/2)
    |> Enum.reduce(%{}, fn i, a -> Map.update(a, i, 1, &(&1 + 1)) end)
    |> Enum.reduce([],
      fn
        {_, v}, a when 0 == rem(v, 2) -> a
        {k, _}, a -> [k] ++ a
      end
    )
    |> Enum.sort()
  end

  # reusable printing function
  def print_set([]), do: IO.puts("  (no members)")
  def print_set(set) do
    IO.write("  ")
    set
    |> Enum.join(":")
    |> IO.puts()
  end

  # main program logic
  def run(args) do
    sets = args
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(&Enum.uniq/1)
    IO.puts("Input Sets:")
    sets
    |> Enum.each(&print_set/1)
    IO.puts("Symmetric Difference:")
    sets
    |> symmetric_difference()
    |> print_set()
    IO.puts("")
  end

  # fixed test cases
  def test() do
    IO.puts("--- USAGE ---")
    main(["help"])
    IO.puts("")
    IO.puts("--- SIMPLE TESTS ---")
    main(["a:b:c"])
    main(["a:b:c", "a:b:c"])
    main(["a:b:c", "d:e:f"])
    IO.puts("")
    IO.puts("--- TESTS ---")
    main(["a:b:c", "c:d"])
    main(["a:c:f:m:n", "b:c:j:k:m:n", "c:d:f:k"])
  end

  # program usage
  def usage() do
    IO.puts("Usage:")
    IO.puts("  #{:escript.script_name()} INPUT [INPUT ...]")
    IO.puts("  #{:escript.script_name()} help")
    IO.puts("  #{:escript.script_name()} test")
    IO.puts("")
    IO.puts("Examples:")
    IO.puts("  #{:escript.script_name()} a:b:c c:d")
    IO.puts("  #{:escript.script_name()} a:c:f:m:n b:c:j:k:m:n c:d:f:k")
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

