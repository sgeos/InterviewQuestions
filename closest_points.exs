#!/usr/bin/env elixir

# PROBLEM:
#   Write a routine that takes a set of points and returns the points
#   closest to the origin.  The routine takes a set of points and the
#   number of points to return.

# EXAMPLE:
#   inputs: points = [(2,1), (0,1), (0,2), (5,5), (0,1), (2,1)], desired number of points = 3
#   outputs: [(0,1), (0,2), (0,1)]

# NOTES:
#   The output can be in any order.

# A single file solution written in Elixir follows.
# To see a list of the command line arguments, run the following.
# This that solution also support working with N-dimensional points,
# and the origin can be specified from the command line.
#   chmod +x closest_points.exs
#   ./closest_points.exs --help
# Examples:
#   ./closest_points.exs
#   ./closest_points.exs -p [2,1],[0,1],[0,2],[5,5],[0,1],[2,1] -r 3
#   ./closest_points.exs -o 3,3 -p [2,1],[0,1],[0,2],[5,5],[0,1],[2,1]
#   ./closest_points.exs -o=-1,1 -p [-1,0],[0,-1],[0,1],[1,0] -r 2 -v
#   ./closest_points.exs -p [0,0,0,0],[-1,3,3,3],[3,-1,3,3],[3,3,-1,3],[3,3,3,-1] -o 0,1,2,3 -r 2

defmodule ClosestPoints do
  def process(pOrigin, pPoints, pResultCount) do
    pPoints
    |> Enum.map(&subtractPoint(&1, pOrigin))
    |> Enum.map(&distanceFromOrigin/1)
    |> Enum.zip(pPoints)
    |> Enum.sort(fn {distanceA,_pa}, {distanceB,_pb} -> distanceA <= distanceB end)
    |> Enum.map(fn {_distance, point} -> point end)
    |> Enum.take(pResultCount)
  end

  def subtractPoint(pA, pB) do
    pA
    |> Enum.zip(pB)
    |> Enum.map(fn {a, b} -> a - b end)
  end

  def distanceFromOrigin(pPoint) do
    pPoint
    |> Enum.reduce(0, fn value, total -> total + value*value end)
  end
end

defmodule Parse do
  def stringToPoint(pString) do
    pString
    |> sanitize
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def stringToPointList(pString) do
    pString
    |> sanitize
    |> String.split("[", trim: true)
    |> Enum.map(&stringToPoint/1)
  end

  def sanitize(pString) do
    pString
    |> standardizeListSeparator
    |> standardizeItemSeparator
    |> stripWhitespace
    |> stripUnusedCharacters
  end

  def standardizeListSeparator(pString) do
    Regex.replace(~r/[<([]/, pString, "[")
  end

  def standardizeItemSeparator(pString) do
    Regex.replace(~r/[,.;:]/, pString, ",")
  end

  def stripWhitespace(pString) do
    Regex.replace(~r/ */, pString, "")
  end

  def stripUnusedCharacters(pString) do
    Regex.replace(~r/[^0-9-,[]/, pString, "")
  end
end

defmodule Script do
  def main(args) do
    defaults = [
      origin: "0,0",
      points: "[0,1],[-1,0]",
      result_count: 1,
      help: false,
    ]
    switches = [
      origin: :string,
      points: :string,
      result_count: :integer,
      verbose: :boolean,
      help: :boolean,
    ]
    aliases = [
      o: :origin,
      p: :points,
      r: :result_count,
      v: :verbose,
      "?": :help,
    ]
    {parsed, remaining, invalid} = OptionParser.parse(args, strict: switches, aliases: aliases)
    options = defaults
    |> Keyword.merge(parsed)
    |> Enum.into(%{})
    cond do
      options[:help] or (0 < length remaining) or (0 < length invalid) ->
        usage
      true ->
        process(options)
    end
  end

  def usage() do
    IO.puts("Given a list of points, find the closest points to the origin.")
    IO.puts("The points, origin and desired number of results can be specified.")
    IO.puts("Usage:")
    IO.puts("  closest_points [--origin ORIGIN] [--points POINTS] [--result-count RESULT_COUNT] [--verbose] [--help]")
    IO.puts("    -o | --origin ORIGIN             : coordinates of origin, default \"0,0\"")
    IO.puts("    -p | --points POINTS             : list of points to use, default \"[0,1],[-1,0]\"")
    IO.puts("    -r | --result-count RESULT_COUNT : number of closest points to return, default 1")
    IO.puts("    -v | --verbose                   : print verbose output, default false")
    IO.puts("    -? | --help                      : display this usage summary")
    IO.puts("Examples:")
    IO.puts("  closest_points")
    IO.puts("  closest_points -p [2,1],[0,1],[0,2],[5,5],[0,1],[2,1] -r 3")
    IO.puts("  closest_points -o 3,3 -p [2,1],[0,1],[0,2],[5,5],[0,1],[2,1]")
    IO.puts("  closest_points -o=-1,1 -p [-1,0],[0,-1],[0,1],[1,0] -r 2 -v")
    IO.puts("  closest_points -p [0,0,0,0],[-1,3,3,3],[3,-1,3,3],[3,3,-1,3],[3,3,3,-1] -o 0,1,2,3 -r 2")
  end

  def process(pOptions) do
    # Parameters
    origin = pOptions[:origin] |> Parse.stringToPoint
    points = pOptions[:points] |> Parse.stringToPointList
    result_count = pOptions[:result_count]
    verbose = pOptions[:verbose]

    # Verbose Output
    if verbose do
      # BUG: When the origin costists of values Erlang considers characters,
      #      these characters are printed instead of the numerical values.
      IO.write "Origin: "
      IO.inspect origin
      IO.write "Points: "
      IO.inspect points
      IO.write "Result Count: "
      IO.inspect result_count
      IO.write "Result: "
    end

    # Result
    ClosestPoints.process(origin, points, result_count)
    |> IO.inspect
  end
end

Script.main(System.argv)

