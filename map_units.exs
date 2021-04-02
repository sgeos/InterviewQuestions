#!/usr/bin/env elixir

# PROBLEM:
# Tactical and strategy games are often about positioning army units on a map.
# Typically maps can be represented by cartesian grids of arbitrarily large sizes.
#
# Implement a data structure that allows:
# - Adding an army unit at a coordinate (x, y);
# - Checking for units at a coordinate (x, y);
# - Scanning the map for units using an **iterator**
#   should start from low y values to high y values.
#
# Expect that scanning is used more often that checking/adding/removing.

defmodule Script do
  # maintain hashmap for individual unit search and a presorted list for scanning the map
  # time complexity is O(N) to maintain the sorted list
  def add_unit({hashmap, sorted_list}, position={x, y}, type) do
    {
      Map.put(hashmap, position, type),
      sorted_list
      # overwrite existing unit at position
      |> Enum.filter(fn {^x, ^y, _} -> false; _ -> true end)
      |> Kernel.++([{x, y, type}])
      # sort by Y, then by X
      |> Enum.sort(
        fn
          {ax, y, _}, {bx, y, _} -> ax <= bx;
          {_, ay, _}, {_, by, _} -> ay <= by      
        end
      )
    }
  end

  # get individual unit from hashmap
  # time complexity is O(1) for a good hashmap
  def get_unit({hashmap, _sorted_list}, position={x, y}) do
    hashmap
    |> Map.get(position)
    |> case do
      nil -> {x, y, :none}
      t -> {x, y, t}
    end
  end
 
  # return presorted list for scanning the map
  # time complexity is O(1)
  def get_sorted_units({_hashmap, sorted_list}) do
    sorted_list
  end

  # test data
  def load_units do
    units = [
      {11, 45, :small_b},
      {11, 44, :small_c},
      {9, 7, :medium},
      {10, 44, :small_a},
      {0, -1, :large},
    ]
    Enum.reduce(units, {%{}, []}, fn {x, y, t}, acc -> add_unit(acc, {x, y}, t) end)
  end

  # test output
  def print_unit_at_position(map_state, search_position) do
    {x, y, type} = get_unit(map_state, search_position)
    IO.puts("(#{x}, #{y}) => #{type}")
  end

  # test output
  def print_all_units(map_state={_hashmap, sorted_list}) do
    sorted_list
    |> Enum.each(
      fn {x, y, _} ->
        print_unit_at_position(map_state, {x, y})
      end
    )
  end

  def test(map_state) do
    IO.puts("Units:")
    [
      {0, 0},
      {11, 44},
      {-1000, -1000},
    ]
    |> Enum.each(&print_unit_at_position(map_state, &1))
    IO.puts("")
    IO.puts("Map Data:")
    print_all_units(map_state)
  end

  # extra polish
  def usage(map_state) do
    IO.puts("Usage:")
    IO.puts("  #{:escript.script_name()} x,y [x,y ...]")
    IO.puts("  #{:escript.script_name()} help")
    IO.puts("  #{:escript.script_name()} test")
    IO.puts("")
    IO.puts("Units: ")
    print_all_units(map_state)
    IO.puts("")
    IO.puts("Examples:")
    IO.puts("  #{:escript.script_name()} 9,7")
    IO.puts("  #{:escript.script_name()} 0,-1 0,0 0,1")
    IO.puts("  #{:escript.script_name()} 10,44 10,45 11,44 11,45")
  end

  # now takes command line arguments
  def main(args) do
    map_state = load_units()
    map_state = add_unit(map_state, {0, 0}, :player)
    args = args |> Enum.map(&String.downcase/1)
    cond do
      Enum.member?(args, "test") -> test(map_state)
      Enum.member?(args, "help") -> usage(map_state)
      0 == length(args) -> usage(map_state)
      true ->
        search_positions = args
          |> Enum.map(fn s ->
            result = String.split(s, ",")
            |> Enum.map(
              fn v ->
                v
                |> Integer.parse
                |> case do
                  {v, _} -> v
                  _ -> :error
                end
              end
            )
            if 2 != length(result) || Enum.member?(result, :error) do
              :error
            else
              List.to_tuple(result)
            end
          end
        )
        unless Enum.member?(search_positions, :error) do
          search_positions
          |> Enum.each(&print_unit_at_position(map_state, &1))
        else
          usage(map_state)
        end
    end
  end
end

# everything starts here
Script.main(System.argv)

