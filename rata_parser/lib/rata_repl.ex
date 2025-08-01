defmodule RataRepl do
  @moduledoc """
  Main REPL interface for the Rata programming language.
  
  Provides an interactive Read-Eval-Print Loop for Rata expressions and statements.
  """

  alias RataRepl.Evaluator

  @prompt "rata> "
  @help_message """
  Rata REPL - Interactive Rata Programming Language Environment
  
  Commands:
    :help    - Show this help message
    :quit    - Exit the REPL
    :clear   - Clear all variables
    :vars    - Show all defined variables
  
  Examples:
    rata> 2 + 3
    5
    rata> x = 42
    42
    rata> x * 2
    84
  """

  @doc """
  Start the REPL loop.
  """
  def start do
    IO.puts("Welcome to Rata REPL!")
    IO.puts("Type :help for help, :quit to exit.")
    loop(%{})
  end

  @doc """
  Main REPL loop with session context.
  """
  def loop(context) do
    input = IO.gets(@prompt) |> String.trim()

    case handle_input(input, context) do
      {:continue, new_context} -> loop(new_context)
      :quit -> IO.puts("Goodbye!")
    end
  end

  # Handle special commands
  defp handle_input(":help", context) do
    IO.puts(@help_message)
    {:continue, context}
  end

  defp handle_input(":quit", _context) do
    :quit
  end

  defp handle_input(":clear", _context) do
    IO.puts("Variables cleared.")
    {:continue, %{}}
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

  # Handle empty input
  defp handle_input("", context) do
    {:continue, context}
  end

  # Handle Rata code
  defp handle_input(input, context) do
    case RataParser.parse_repl(input) do
      {:ok, ast} ->
        case Evaluator.eval(ast, context) do
          {:ok, value, new_context} ->
            IO.puts(format_value(value))
            {:continue, new_context}
          {:error, reason} ->
            IO.puts("Error: #{reason}")
            {:continue, context}
        end
      {:error, reason} ->
        IO.puts("Parse error: #{inspect(reason)}")
        {:continue, context}
    end
  end

  # Format values for display
  defp format_value(value) when is_number(value), do: to_string(value)
  defp format_value(value) when is_boolean(value), do: to_string(value)
  defp format_value(value), do: inspect(value)
end