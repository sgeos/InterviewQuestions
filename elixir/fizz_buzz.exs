#!/usr/bin/env elixir

# PROBLEM:
#   Write a program that prints the numbers from 1 to 100.
#   But for multiples of three print "Fizz" instead of the number
#   and for the multiples of five print "Buzz".
#   For numbers which are multiples of both three and five print "FizzBuzz".

# REFERENCE:
#   https://blog.codinghorror.com/why-cant-programmers-program/

# A single file solution written in Elixir follows.
# To see a list of the command line arguments, run the following.
# Note that fizz and buzz multiples can be specified from the command line.
#   chmod +x fizz_buzz.exs
#   ./fizz_buzz.exs --help
# Examples:
#   ./fizz_buzz.exs
#   ./fizz_buzz.exs -s 2 -F Big... -B Scary... -W Monsters!
#   ./fizz_buzz.exs -n 50 -x 75
#   ./fizz_buzz.exs -n 50 -x 75 -s 5
#   ./fizz_buzz.exs -f 2 -b 3
#   ./fizz_buzz.exs -n 0 -x 300 -s 3 -f 5 -b 7
#   ./fizz_buzz.exs -n 0 -x 300 -s 11 -f 5 -b 7 -i

defmodule FizzBuzz do
  def think(pValue, pOptions) do
    fizz_multiple = pOptions[:fizz]
    buzz_multiple = pOptions[:buzz]
    fizz = 0 == rem(pValue, fizz_multiple)
    buzz = 0 == rem(pValue, buzz_multiple)
    think(pValue, fizz, buzz, pOptions)
  end
  def think(pValue, true, true, pOptions), do: {pValue, pOptions[:fizzbuzz_word]}
  def think(pValue, true, false, pOptions), do: {pValue, pOptions[:fizz_word]}
  def think(pValue, false, true, pOptions), do: {pValue, pOptions[:buzz_word]}
  def think(pValue, false, false, _pOptions), do: {pValue, pValue}

  def say({_pIndex, pValue}, false), do: IO.puts("#{pValue}")
  def say({pIndex, pValue}, true), do: IO.puts("#{pIndex} -> #{pValue}")
  def say(pOutput, pOptions), do: say(pOutput, pOptions[:index])

  def count(pOptions) do
    min = pOptions[:min]
    max = pOptions[:max]
    skip = pOptions[:skip]
    min..max
    |> Enum.take_every(skip)
    |> Enum.map(&(think(&1,pOptions)))
    |> Enum.each(&(say(&1,pOptions)))
  end
end

defmodule Script do
  def main(args) do
    defaults = [
      fizz_word: "Fizz",
      buzz_word: "Buzz",
      fizzbuzz_word: "FizzBuzz",
      fizz: 3,
      buzz: 5,
      min: 1,
      max: 100,
      skip: 1,
      index: false,
      help: false,
    ]
    switches = [
      fizz_word: :string,
      buzz_word: :string,
      fizzbuzz_word: :string,
      fizz: :integer,
      buzz: :integer,
      min: :integer,
      max: :integer,
      skip: :integer,
      index: :boolean,
      help: :boolean,
    ]
    aliases = [
      F: :fizz_word,
      B: :buzz_word,
      W: :fizzbuzz_word,
      f: :fizz,
      b: :buzz,
      n: :min,
      x: :max,
      s: :skip,
      i: :index,
      "?": :help,
    ]
    {parsed, remaining, invalid} = OptionParser.parse(args, strict: switches, aliases: aliases)
    options = defaults
    |> Keyword.merge(parsed)
    cond do
      options[:help] or (0 < length remaining) or (0 < length invalid) ->
        usage
      true ->
        process(options)
    end
  end

  def usage() do
    IO.puts("Counts from a minimum number to a maximum number.")
    IO.puts("Fizz multiples are replaced with 'Fizz', buzz multiples with 'Buzz' and multiples of fizz and buzz with 'FizzBuzz'.")
    IO.puts("Usage:")
    IO.puts("  fizz_buzz [--fizz-word FIZZWORD] [--buzz-word BUZZWORD] [--fizzbuzz-word FIZZBUZZWORD] [--fizz FIZZ] [--buzz BUZZ] [--min MIN] [--max MAX] [--skip SKIP] [--help]")
    IO.puts("    --fizz-word FIZZWORD         : word to say on fizz multiple, default \"Fizz\"")
    IO.puts("    -F                           : word to say on fizz multiple, default \"Fizz\"")
    IO.puts("    --buzz-word BUZZWORD         : word to say on buzz multiple, default \"Buzz\"")
    IO.puts("    -B                           : word to say on buzz multiple, default \"Buzz\"")
    IO.puts("    --fizzbuzz-word FIZZBUZZWORD : word to say on fizzbuzz multiple, default \"FizzBuzz\"")
    IO.puts("    -W                           : word to say on fizzbuzz multiple, default \"FizzBuzz\"")
    IO.puts("    --fizz FIZZ                  : fizz multiple, default 3")
    IO.puts("    -f     FIZZ                  : fizz multiple, default 3")
    IO.puts("    --buzz BUZZ                  : buzz multiple, default 5")
    IO.puts("    -b     BUZZ                  : buzz multiple, default 5")
    IO.puts("    --min  MIN                   : number to count from, default 1")
    IO.puts("    -n     MIN                   : number to count from, default 1")
    IO.puts("    --max  MAX                   : number to count to, default 100")
    IO.puts("    -x     MAX                   : number to count to, default 100")
    IO.puts("    --skip SKIP                  : multiple to count by, default 1")
    IO.puts("    -s     SKIP                  : multiple to count by, default 1")
    IO.puts("    --index                      : display count number for each line of output")
    IO.puts("    -i                           : display count number for each line of output")
    IO.puts("    --help                       : display this usage summary")
    IO.puts("    -?                           : display this usage summary")
    IO.puts("Examples:")
    IO.puts("  fizz_buzz")
    IO.puts("  fizz_buzz -s 2 -F Big... -B Scary... -W Monsters!")
    IO.puts("  fizz_buzz -n 50 -x 75")
    IO.puts("  fizz_buzz -n 50 -x 75 -s 5")
    IO.puts("  fizz_buzz -f 2 -b 3")
    IO.puts("  fizz_buzz -n 0 -x 300 -s 3 -f 5 -b 7")
    IO.puts("  fizz_buzz -n 0 -x 300 -s 11 -f 5 -b 7 -i")
  end

  def process(pOptions) do
    FizzBuzz.count(pOptions)
  end
end

Script.main(System.argv)

