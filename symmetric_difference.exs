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
#   ./symmetric_difference.exs

defmodule CustomSet do
  def symmetricDifference(pSetA, pSetB) do
    setA = MapSet.new(pSetA)
    setB = MapSet.new(pSetB)
    union = MapSet.union(setA, setB)
    intersection = MapSet.intersection(setA, setB)
    MapSet.difference(union, intersection)
    |> MapSet.to_list
  end
end

defmodule Script do
  def main(args) do
    defaults = [
      token: ",",
      character: false,
      strip: false,
      help: false,
    ]
    switches = [
      token: :string,
      character: :boolean,
      strip: :boolean,
      help: :boolean,
    ]
    aliases = [
      t: :token,
      c: :character,
      s: :strip,
      "?": :help,
    ]
    {parsed, remaining, invalid} = OptionParser.parse(args, strict: switches, aliases: aliases)
    options = defaults
    |> Keyword.merge(parsed)
    cond do
      options[:help] or (0 < length invalid) ->
        usage
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
    IO.puts("    --help      : display this usage summary")
    IO.puts("    -?          : display this usage summary")
    IO.puts("Examples:")
    IO.puts("  symmetric_difference")
    IO.puts("  symmetric_difference -c a ab abc")
    IO.puts("  symmetric_difference -t : red:yellow:green red:green:blue")
    IO.puts("  symmetric_difference -s '1, 3, 5, 7, 9' '2, 3, 5, 7'")
    IO.puts("  symmetric_difference -s '1, 2, 3, 5, 8' '1, 4, 9' '2, 4, 8' '1, 3, 5, 7, 9' '2, 3, 5, 7'")
  end

  def stringToSet(pSet, _pToken, true, _), do: String.to_charlist(pSet) |> Enum.map(&(to_string([&1]))) |> Enum.uniq
  def stringToSet(pSet, pToken, false, true), do: pSet |> String.split(pToken) |> Enum.map(&String.trim/1) |> Enum.uniq
  def stringToSet(pSet, pToken, false, false), do: pSet |> String.split(pToken) |> Enum.uniq

  def process(pSetList, pOptions) do
    token = pOptions[:token]
    character = pOptions[:character]
    strip = pOptions[:strip]
    pSetList
    |> Enum.map(&stringToSet(&1, token, character, strip))
    |> Enum.reduce([], &CustomSet.symmetricDifference/2)
    |> Enum.sort
    |> Enum.each(&IO.puts/1)
  end
end

Script.main(System.argv)

