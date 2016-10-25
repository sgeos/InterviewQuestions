#!/usr/bin/env elixir

# PROBLEM:
#   Write a routine that run length encodes strings.
#   You may use any language.
#   Example Input  : abbbccddddddefff
#   Example Output : a1b3c2d6e1f3

# A single file solution written in Elixir follows.
# This solution also includes a routine to run length decode strings.
# To see a list of the command line arguments, run the following.
#   chmod +x rle.exs
#   ./rle.exs --help
# Examples:
#   ./rle.exs abbbccddddddefff
#   ./rle.exs -s abbbccddddddefff
#   ./rle.exs -d a1b3c2d6e1f3
#   ./rle.exs -d ab3c2d6ef3

defmodule RLE do
  defp encoder(pItem, {pItem, pCount, pOutput}), do: {pItem, pCount + 1, pOutput}
  defp encoder(pNewItem, {pItem, pCount, pOutput}), do: {pNewItem, 1, finishEncodingItem({pItem, pCount, pOutput})}
  defp finishEncodingItem({nil, _pCount, pOutput}), do: pOutput
  defp finishEncodingItem({pItem, 0, pOutput}), do: pOutput ++ [{pItem, 1}] # for short decoding
  defp finishEncodingItem({pItem, pCount, pOutput}), do: pOutput ++ [{pItem, pCount}]

  def encode(pInputList) do
    pInputList
    |> Enum.reduce({nil, 0, []}, &encoder/2)
    |> finishEncodingItem()
  end

  defp itemToString(pItem, 1, true), do: "#{pItem}" # short encoding
  defp itemToString(pItem, pCount, _), do: "#{pItem}#{pCount}"

  def encodeString(pInputString, pShortEncoding \\ false) do
    pInputString
    |> String.to_charlist
    |> Enum.map(&(to_string([&1])))
    |> encode
    |> Enum.map(fn {pItem, pCount} -> itemToString(pItem, pCount, pShortEncoding) end)
    |> Enum.reverse
    |> Enum.reduce("", &Kernel.<>/2)
  end

  def decode(pInputList) do
    pInputList
    |> Enum.map(fn {pItem, pCount} -> List.duplicate(pItem, pCount) end)
    |> Enum.reverse
    |> Enum.reduce([], &Kernel.++/2)
  end

  defp stringDecoder(pCharacter, {pItem, pCount, pOutput}) when pCharacter in ?0..?9, do: {pItem, pCount * 10 + pCharacter - ?0, pOutput}
  defp stringDecoder(pCharacter, {pItem, pCount, pOutput}), do: {pCharacter, 0, finishEncodingItem({pItem, pCount, pOutput})}

  def decodeString(pInputString) do
    pInputString
    |> String.to_charlist
    |> Enum.reduce({nil, 0, []}, &stringDecoder/2)
    |> finishEncodingItem()
    |> decode
    |> Enum.map(&(to_string([&1])))
    |> Enum.reverse
    |> Enum.reduce("", &Kernel.<>/2)
  end
end

defmodule Script do
  def main(args) do
    defaults = [
      decode: false,
      short: false,
      help: false,
    ]
    switches = [
      decode: :boolean,
      short: :boolean,
      help: :boolean,
    ]
    aliases = [
      d: :decode,
      s: :short,
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
    IO.puts("Run length encode (or decode) input strings.")
    IO.puts("Usage:")
    IO.puts("  rle [--decode] STRING_A [STRING_B ...]")
    IO.puts("    --short  : do not encode 1 after run length 1 items")
    IO.puts("    -s       : do not encode 1 after run length 1 items")
    IO.puts("    --decode : decode strings instead of encoding them")
    IO.puts("    -d       : decode strings instead of encoding them")
    IO.puts("    --help   : display this usage summary")
    IO.puts("    -?       : display this usage summary")
    IO.puts("Examples:")
    IO.puts("  rle abbbccddddddefff")
    IO.puts("  rle -s abbbccddddddefff")
    IO.puts("  rle -d a1b3c2d6e1f3")
    IO.puts("  rle -d ab3c2d6ef3")
  end

  def process(pSetList, pOptions) do
    decode = pOptions[:decode]
    short = pOptions[:short]
    pSetList
    |> Enum.map(fn pInputString -> encodeString(pInputString, decode, short) end)
    |> Enum.each(&IO.puts/1)
  end

  def encodeString(pInputString, false, pShort), do: RLE.encodeString(pInputString, pShort)
  def encodeString(pInputString, true, _pShort), do: RLE.decodeString(pInputString)
end

Script.main(System.argv)

