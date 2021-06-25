#!/usr/bin/env elixir

# I found this on my drive, but it was not committed to GitHub.
# No clue what the status is, but I may as well commit it.

# PROBLEM:
#   Single linked list, print backwards.
#     head = [payload: value, next: next_object]
#     head[:next] = [payload: value2, next: next_object2]

# y  = f(x)
# y' = h(g(f(x)))
# 
# y_not = x
# |> f
# |> g
# |> h

defmodule InterviewProblem do
  # nil for empty list
  def print_backwards(nil) do
    nil
    |> IO.inspect
  end

  def print_backwards({value, nil}) do
    value
    |> IO.inspect
  end

  def print_backwards({value, next_node}) do
    print_backwards(next_node)
    value
    |> IO.inspect
  end
  
  def print_linked_list(list) do
    list
    
    |> IO.inspect
  end
end

defmodule Utility do
  def reverse_linked_list({value, next_node} = list) do
    list[:final_value]
  end

  def reverse_linked_list({value, next_node} = list) do
    # transform here
    reverse_linked_list(list[:not_final])
  end
end

defmodule Script do
  def main(args) do
  
  end
  
  def usage() do
    IO.puts("Description")
    IO.puts("Usage:")
    IO.puts("  interview_problem [--option OPTION]")
    IO.puts("Examples:")
    IO.puts("  interview_problem")
    IO.puts("  interview_problem --option OPTION")
  end
  
  def process(pOptions) do
  end
end

Script.main(System.argv)

