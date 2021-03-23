#!/usr/bin/env elixir

# PROBLEM:
# Given the following data, write a routine to convert from one currency to another.
#
# {:jpy, :usd} => 0.0092,
# {:jpy, :euro} => 0.0078,
# {:usd, :cad} => 1.26,
# {:usd, :aud} => 1.3,
# {:usd, :pond} => 0.73,
# {:pond, :sfr} => 1.29,
# {:euro, :sfr} => 1.11,
#
# Note that the program should be able to convert from any of the listed currencies to
# any of the other listed currencies.  For example, JPY -> USD -> CAD.
#
# After getting to the point where my solution fails to convert from POND to EURO
# through SFR, I would have to say that this is a good interview question.  In retrospect,
# I would just fill out an NxN lookup table on initialization.  Alternatively, I could
# cull the list of supported currencies to prevent an infinite recursive search.
#
# This attempt kind of works, and it will need to be good enough.
# If I were to revisit this problem, I would try something like this.
#
#  0. Sanity check input.
#  1. Create NxN sparse matrix with above data points.  Add reverse conversions.
#  2. Return the final answer if the conversion is in the table.
#  3. Create a list of unsolved conversions.
#  3a. For each unsolved conversion:
#  3b. Attempt to the find solution using only two existing conversions (A -> B -> C).
#  3c. Remove from list if solved, otherwise save for next pass.
#  4. Return the final answer if conversion is in the table.
#  5. Go to 3a.  (There is finite space, so this will terminate given sane data.)

defmodule Script do
  # this should probably be precomputed only once
  def currencies(rates) do
    rates
    |> Enum.reduce([], fn {{from, to}, _}, acc -> acc ++ [from, to] end)
    |> Enum.uniq
  end

  # not what I wanted, but I made it work
  def conversion_flatmap(conversions, acc, key) do
    if values = conversions[key] do
      Enum.flat_map(values, fn v -> conversion_flatmap(conversions, acc ++ [key], v) end)
    else
      acc ++ [key]
    end
  end

  # this is what I used to make the flatmap work
  def conversion_list(_conversions, from, from), do: [[from, from]]
  def conversion_list(conversions, from, to) do
    {result, _} =
      conversions
      |> conversion_flatmap([], from)
      # specifically, this reduce
      |> Enum.reduce({[],nil},
        fn
          ^from, {l,_} -> {l,[from]}
          _, a={_,nil} -> a
          ^to, {l,pl} -> {l++[pl++[to]], nil}
          next, {l,pl} -> {l,pl++[next]}
          _, a -> a
        end
      )
    result
    # duplicates can happen
    |> Enum.uniq
  end

  def build_rate_chain_list(rates, from, to) do
    # this should be precomputed and stored, but it will be left as is
    conversions = 
      Enum.reduce(rates, %{},
        fn {{from, to}, _}, a ->
          {_, a} = Map.get_and_update(a, from, fn c -> {c, (c || []) ++ [to]} end)
          a
        end
      )
    conversion_list(conversions, from, to)
  end

  # this is basically a custom reduce
  def resolve_rate_chain(_rates, [_h | []], a), do: a
  def resolve_rate_chain(_rates, [from, from], a), do: a
  def resolve_rate_chain(rates, [h | t], a) do
    resolve_rate_chain(rates, t, a * rates[{h, List.first(t)}])
  end

  # handles inverse and reverse, but needs a new strategy to handle EURO -> SFR -> POND
  def convert(rates, from, to) do
    result = build_rate_chain_list(rates, from, to)
    |> Enum.map(fn r -> {r, resolve_rate_chain(rates, r, 1)} end)
    if 0 < length(result) do
      result
    else
      build_rate_chain_list(rates, to, from)
      |> Enum.map(fn r -> {r |> Enum.reverse, 1/resolve_rate_chain(rates, r, 1)} end)
    end
  end

  # it is used a couple of times
  def print_rate_header(rate_list) do
    rate_list
    |> Enum.join(" -> ")
    |> IO.write
    IO.write(" = ")
  end

  # for visual feedback
  def print_rate(rates, from, to) do
    rate_list = convert(rates, from, to)
    if 0 < length(rate_list) do
      Enum.each(rate_list, fn {r, v} -> print_rate_header(r); IO.puts("#{v}") end)
    else
      print_rate_header([from, to])
      IO.puts("ERROR")
    end
  end

  # may as well put all of these in one place
  def test(rates) do
    IO.puts("--- Forward ---")
    main(["jpy:usd", "jpy:euro", "usd:cad", "usd:aud", "usd:pond", "pond:sfr", "euro:sfr"])

    IO.puts("\n--- Backward ---")
    main(["usd:jpy", "euro:jpy", "cad:usd", "aud:usd", "pond:usd", "sfr:pond", "sfr:euro"])

    IO.puts("\n--- Chain Conversion ---")
    main(["jpy:cad", "jpy:sfr", "cad:jpy", "sfr:jpy"])

    IO.puts("\n--- Self Conversion ---")
    main(["aud:aud", "cad:cad", "euro:euro", "jpy:jpy", "pond:pond", "sfr:sfr", "usd:usd"])

    IO.puts("\n--- Full Test ---")
    rates
    |> currencies
    |> Enum.map(fn i -> rates |> currencies |> Enum.map(fn j -> {i, j} end) end)
    |> Enum.reduce([], &Kernel.++/2)
    |> Enum.each(fn {from, to} -> print_rate(rates, from, to) end)

    IO.puts("\n--- Bad Conversion ---")
    print_rate(rates, :btc, :btc)
    print_rate(rates, :usd, :btc)
    print_rate(rates, :btc, :usd)
  end

  # extra polish
  def usage(rates) do
    IO.puts("Usage:")
    IO.puts("  #{:escript.script_name()} FROM:TO [FROM:TO ...]")
    IO.puts("  #{:escript.script_name()} help")
    IO.puts("  #{:escript.script_name()} test")
    IO.puts("")
    IO.write("Currencies: ")
    rates
    |> currencies
    |> Enum.sort
    |> Enum.map(&Atom.to_string/1)
    |> Enum.map(&String.upcase/1)
    |> Enum.join(", ")
    |> IO.puts
    IO.puts("")
    IO.puts("Example:")
    IO.puts("  #{:escript.script_name()} SFR:USD JPY:SFR POND:EURO USD:JPY")
  end

  # now takes command line arguments
  def main(args) do
    rates = %{
      {:jpy, :usd} => 0.0092,
      {:jpy, :euro} => 0.0078,
      {:usd, :cad} => 1.26,
      {:usd, :aud} => 1.30,
      {:usd, :pond} => 0.73,
      {:pond, :sfr} => 1.29,
      {:euro, :sfr} => 1.11,
    }
    currencies = rates |> currencies
    args = args |> Enum.map(&String.downcase/1)
    cond do
      Enum.member?(args, "test") -> test(rates)
      Enum.member?(args, "help") -> usage(rates)
      0 == length(args) -> usage(rates)
      true ->
        job_list = args
          |> Enum.map(fn s ->
            result = String.split(s, ":") |> Enum.map(&String.to_atom/1)
            if [true] == result |> Enum.map(&Enum.member?(currencies, &1)) |> Enum.uniq do
              result
            else
              :error
            end
          end
        )
        unless Enum.member?(job_list, :error) do
          job_list |> Enum.each(fn [from, to] -> print_rate(rates, from, to) end)
        else
          usage(rates)
        end
    end
  end
end

# everythign starts here
Script.main(System.argv)

