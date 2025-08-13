#!/usr/bin/env elixir

# REPL without external dependencies
# Uses simple string matching instead of nimble_parsec

# Add the lib directory to the code path
Code.prepend_path("lib")

# Load our modules (skip the ones that need nimble_parsec)
Code.require_file("lib/rata_modules/core.ex")
Code.require_file("lib/rata_modules/math.ex")
Code.require_file("lib/rata_modules/log.ex")
Code.require_file("lib/rata_modules/stats.ex")
Code.require_file("lib/rata_modules/maps.ex")
Code.require_file("lib/rata_modules/list.ex")
Code.require_file("lib/rata_modules/table.ex")
Code.require_file("lib/rata_modules/set.ex")
Code.require_file("lib/rata_modules/enum.ex")
Code.require_file("lib/rata_modules/vector.ex")
Code.require_file("lib/rata_modules/datetime.ex")
Code.require_file("lib/rata_modules/file.ex")

defmodule SimpleEvaluator do
  def eval(input) do
    cond do
      String.match?(input, ~r/^\d+\s*\+\s*\d+$/) ->
        [left, right] = String.split(input, "+") |> Enum.map(&String.trim/1) |> Enum.map(&String.to_integer/1)
        {:ok, left + right}
      
      String.match?(input, ~r/^\d+\s*\-\s*\d+$/) ->
        [left, right] = String.split(input, "-") |> Enum.map(&String.trim/1) |> Enum.map(&String.to_integer/1)
        {:ok, left - right}
        
      String.match?(input, ~r/^\d+\s*\*\s*\d+$/) ->
        [left, right] = String.split(input, "*") |> Enum.map(&String.trim/1) |> Enum.map(&String.to_integer/1)
        {:ok, left * right}
        
      String.match?(input, ~r/^\d+$/) ->
        {:ok, String.to_integer(input)}
        
      true ->
        {:error, "Simple parser - only supports basic arithmetic like: 2 + 3, 5 * 4, etc."}
    end
  end
end

defmodule SimplifiedRepl do
  def start do
    IO.puts("Simplified Rata REPL!")
    IO.puts("Type :help for help, :quit to exit.")
    IO.puts("Modules loaded: Core, Math, Log, Stats, Maps, List, Table, Set, Enum, Vector, Datetime, File")
    IO.puts("")
    loop(%{})
  end

  def loop(context) do
    input = IO.gets("rata> ") |> String.trim()

    case handle_input(input, context) do
      {:continue, new_context} -> loop(new_context)
      :quit -> IO.puts("Goodbye!")
    end
  end

  defp handle_input(":help", context) do
    IO.puts("""
    Simplified Rata REPL Commands:
      :help    - Show this help message
      :quit    - Exit the REPL
      :vars    - Show all defined variables
      :modules - List available modules
    
    Simple expressions supported:
      2 + 3    - Addition
      5 - 2    - Subtraction  
      4 * 6    - Multiplication
      42       - Numbers
    """)
    {:continue, context}
  end

  defp handle_input(":quit", _context) do
    :quit
  end

  defp handle_input(":vars", context) do
    if Enum.empty?(context) do
      IO.puts("No variables defined.")
    else
      IO.puts("Defined variables:")
      Enum.each(context, fn {name, value} ->
        IO.puts("  #{name} = #{inspect(value)}")
      end)
    end
    {:continue, context}
  end

  defp handle_input(":modules", context) do
    IO.puts("Available modules:")
    IO.puts("  RataModules.Core - Core functionality")
    IO.puts("  RataModules.Math - Mathematical operations")
    IO.puts("  RataModules.Vector - Vector operations")
    IO.puts("  RataModules.List - List operations")
    IO.puts("  RataModules.Maps - Map operations")
    IO.puts("  RataModules.Set - Set operations")
    IO.puts("  RataModules.Enum - Enumeration functions")
    IO.puts("  RataModules.Stats - Statistical functions")
    IO.puts("  RataModules.Datetime - Date/time operations")
    IO.puts("  RataModules.File - File operations")
    IO.puts("  RataModules.Log - Logging functions")
    IO.puts("  RataModules.Table - Table operations")
    {:continue, context}
  end

  defp handle_input("", context) do
    {:continue, context}
  end

  defp handle_input(input, context) do
    case SimpleEvaluator.eval(input) do
      {:ok, value} ->
        IO.puts(format_value(value))
        {:continue, context}
      {:error, reason} ->
        IO.puts("Error: #{reason}")
        {:continue, context}
    end
  end

  defp format_value(value) when is_number(value), do: to_string(value)
  defp format_value(value) when is_boolean(value), do: to_string(value)
  defp format_value(value), do: inspect(value)
end

# Start the simplified REPL
SimplifiedRepl.start()