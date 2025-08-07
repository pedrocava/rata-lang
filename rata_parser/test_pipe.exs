#!/usr/bin/env elixir

# Simple test script for pipe operator functionality
Code.require_file("lib/rata_parser.ex", ".")
Code.require_file("lib/rata_repl/evaluator.ex", ".")
Code.require_file("lib/rata_modules/math.ex", ".")

alias RataParser.Parser
alias RataRepl.Evaluator

# Test simple pipe operation: 5 |> Math.add(3)
IO.puts("Testing pipe operator: 5 |> Math.add(3)")

# Parse the expression
input_tokens = [
  {:integer, 5}, :pipe, {:identifier, "Math"}, :dot, {:identifier, "add"}, :left_paren, {:integer, 3}, :right_paren
]

case Parser.expression(input_tokens) do
  {:ok, [ast], "", %{}, _, _} ->
    IO.puts("Parsed AST: #{inspect(ast)}")
    
    # Evaluate the expression  
    case Evaluator.eval(ast, %{}) do
      {:ok, result, _context} ->
        IO.puts("Result: #{result}")
        IO.puts("✅ Pipe test passed!")
      {:error, reason} ->
        IO.puts("❌ Evaluation error: #{reason}")
    end
  {:error, reason} ->
    IO.puts("❌ Parse error: #{reason}")
end