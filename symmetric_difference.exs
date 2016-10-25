#!/usr/bin/env elixir

# PROBLEM:
#   Write a routine that returns the symmetric difference of two sets.
#   The symmetric difference of two sets is the set of elements
#   which are in either of the sets and not in their intersection.

# NOTES:
#   This is the kind of question where instructions may be given
#   to solve the problem without using libraries functions.
#   In that scenario the input is assumed to be clean and useful.
#   This is a realistic solution where library functions are used.
#   The hard work is parsing user command line input into sets that
#   can be used by the library functions.

# A single file solution written in Elixir follows.
# This solution will find the symmetric difference of any number
# of sets, not just two.
# To see a list of the command line arguments, run the following.
#   chmod +x symmetric_difference.exs
#   ./symmetric_difference.exs --help
# Examples:
#   ./symmetric_difference.exs -c a ab abc
#   ./symmetric_difference.exs -t : red:yellow:green red:green:blue
#   ./symmetric_difference.exs -s '1, 3, 5, 7, 9' '2, 3, 5, 7'
#   ./symmetric_difference.exs -s '1, 2, 3, 5, 8' '1, 4, 9' '2, 4, 8' '1, 3, 5, 7, 9' '2, 3, 5, 7'
#   ./symmetric_difference.exs -s -o '1, 2, 3, 5, 8' '1, 4, 9' '2, 4, 8' '1, 3, 5, 7, 9' '2, 3, 5, 7'
#   ./symmetric_difference.exs -b
#   ./symmetric_difference.exs -b -x 5000000 -c 100

defmodule CustomSet do
  def symmetricDifference_IntersectionDifference(pSetA, pSetB) do
    setA = MapSet.new(pSetA)
    setB = MapSet.new(pSetB)
    union = MapSet.union(setA, setB)
    intersection = MapSet.intersection(setA, setB)
    MapSet.difference(union, intersection)
    |> MapSet.to_list
  end

  # FEEDBACK:
  #   benchmark your formula of union(a,b)\intersection(a,b) with union(a\b,b\a)
  #   just curious about relative costs. does 1U+1I+1D cost less or more than 2D+1U
  #
  # ANSWER:
  #   2D+1U appears to be slightly faster when operating on multiple large sets
  def symmetricDifference_DifferenceUnion(pSetA, pSetB) do
    setA = MapSet.new(pSetA)
    setB = MapSet.new(pSetB)
    differenceA = MapSet.difference(setA, setB)
    differenceB = MapSet.difference(setB, setA)
    MapSet.union(differenceA, differenceB)
    |> MapSet.to_list
  end
end

# REFERENCE:
#   http://stackoverflow.com/questions/29668635/how-can-we-easily-time-function-calls-in-elixir
defmodule Benchmark do
  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

defmodule Script do
  def main(args) do
    defaults = [
      token: ",",
      character: false,
      strip: false,
      original: false,
      benchmark: false,
      max: 1000000,
      count: 12,
      help: false,
    ]
    switches = [
      token: :string,
      character: :boolean,
      strip: :boolean,
      original: :boolean,
      benchmark: :boolean,
      max: :integer,
      count: :integer,
      help: :boolean,
    ]
    aliases = [
      t: :token,
      c: :character,
      s: :strip,
      o: :original,
      b: :benchmark,
      x: :max,
      n: :count,
      "?": :help,
    ]
    {parsed, remaining, invalid} = OptionParser.parse(args, strict: switches, aliases: aliases)
    options = defaults
    |> Keyword.merge(parsed)
    cond do
      options[:help] or (0 < length invalid) ->
        usage
      options[:benchmark] ->
        benchmark(options)
      true ->
        process(remaining, options)
    end
  end

  def usage() do
    IO.puts("Calculate the symmetric difference of a number of sets.")
    IO.puts("Usage:")
    IO.puts("  symmetric_difference [--token T] [--character] [--strip] SET_A SET_B [SET_C ...]")
    IO.puts("    --token T   : token used to separate set item, comma is the default \",\"")
    IO.puts("    -t      T   : token used to separate set item, comma is the default \",\"")
    IO.puts("    --character : operate on sets of characters instead of sets of strings")
    IO.puts("    -c          : operate on sets of characters instead of sets of strings")
    IO.puts("    --strip     : strip leading and trailing whitespace from set items")
    IO.puts("    -s          : strip leading and trailing whitespace from set items")
    IO.puts("    --original  : use original algorithm (subtract intersection from union) as opposed to faster algorith (union of differences)")
    IO.puts("    -o          : use original algorithm (subtract intersection from union) as opposed to faster algorith (union of differences)")
    IO.puts("    --benchmark : perform algorithm benchmark")
    IO.puts("    -b          : perform algorithm benchmark")
    IO.puts("    --max       : benchmark range max, default 1000000")
    IO.puts("    -x          : benchmark range max, default 1000000")
    IO.puts("    --count     : benchmark set count, default 12")
    IO.puts("    -n          : benchmark set count, default 12")
    IO.puts("    --help      : display this usage summary")
    IO.puts("    -?          : display this usage summary")
    IO.puts("Examples:")
    IO.puts("  symmetric_difference -c a ab abc")
    IO.puts("  symmetric_difference -t : red:yellow:green red:green:blue")
    IO.puts("  symmetric_difference -s '1, 3, 5, 7, 9' '2, 3, 5, 7'")
    IO.puts("  symmetric_difference -s '1, 2, 3, 5, 8' '1, 4, 9' '2, 4, 8' '1, 3, 5, 7, 9' '2, 3, 5, 7'")
    IO.puts("  symmetric_difference -s -o '1, 2, 3, 5, 8' '1, 4, 9' '2, 4, 8' '1, 3, 5, 7, 9' '2, 3, 5, 7'")
    IO.puts("  symmetric_difference -b")
    IO.puts("  symmetric_difference -b -x 5000000 -c 100")
  end

  def stringToSet(pSet, _pToken, true, _), do: String.to_charlist(pSet) |> Enum.map(&(to_string([&1]))) |> Enum.uniq
  def stringToSet(pSet, pToken, false, true), do: pSet |> String.split(pToken) |> Enum.map(&String.trim/1) |> Enum.uniq
  def stringToSet(pSet, pToken, false, false), do: pSet |> String.split(pToken) |> Enum.uniq

  def process(pSetList, pOptions) do
    token = pOptions[:token]
    character = pOptions[:character]
    strip = pOptions[:strip]
    original = pOptions[:original]
    pSetList
    |> Enum.map(&stringToSet(&1, token, character, strip))
    |> Enum.reduce([], fn pSetA, pSetB -> symmetricDifference(pSetA, pSetB, original) end)
    |> Enum.sort
    |> Enum.each(&IO.puts/1)
  end

  def symmetricDifference(pSetA, pSetB, true), do: CustomSet.symmetricDifference_IntersectionDifference(pSetA, pSetB)
  def symmetricDifference(pSetA, pSetB, false), do: CustomSet.symmetricDifference_DifferenceUnion(pSetA, pSetB)

  def benchmark(pOptions) do
    range_max = pOptions[:max]
    input_max = pOptions[:count]
    range = 0..range_max
    input = 1..input_max
    |> Enum.map(&(range |> Enum.take_every(&1)))
    Benchmark.measure(fn -> input |> Enum.reduce([], &CustomSet.symmetricDifference_IntersectionDifference/2) end)
    |> fn time -> IO.puts("Intersection Difference : #{time} seconds") end.()
    Benchmark.measure(fn -> input |> Enum.reduce([], &CustomSet.symmetricDifference_DifferenceUnion/2) end)
    |> fn time -> IO.puts("Difference Union        : #{time} seconds") end.()
  end
end

Script.main(System.argv)

