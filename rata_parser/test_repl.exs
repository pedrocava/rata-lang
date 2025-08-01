#!/usr/bin/env elixir

# Test script for the REPL components
Mix.install([{:nimble_parsec, "~> 1.4"}])

# Add the lib directory to the code path
Code.prepend_path("lib")

# Load our modules
Code.require_file("lib/rata_parser/ast.ex")
Code.require_file("lib/rata_parser/lexer.ex") 
Code.require_file("lib/rata_parser/parser.ex")
Code.require_file("lib/rata_parser.ex")
Code.require_file("lib/rata_repl/evaluator.ex")

defmodule TestRepl do
  alias RataRepl.Evaluator

  def test_parser do
    IO.puts("=== Testing REPL Parser ===")
    
    test_cases = [
      "2 + 3",
      "x = 42",
      "10 * 5",
      "y = x + 1"
    ]
    
    Enum.each(test_cases, fn input ->
      IO.puts("Input: #{input}")
      case RataParser.parse_repl(input) do
        {:ok, ast} ->
          IO.puts("  AST: #{inspect(ast)}")
        {:error, reason} ->
          IO.puts("  Error: #{inspect(reason)}")
      end
      IO.puts("")
    end)
  end

  def test_evaluator do
    IO.puts("=== Testing Evaluator ===")
    
    # Test simple literal
    {:ok, ast} = RataParser.parse_repl("42")
    IO.puts("42:")
    IO.inspect(Evaluator.eval(ast, %{}))
    
    # Test binary operation
    {:ok, ast} = RataParser.parse_repl("2 + 3")
    IO.puts("2 + 3:")
    IO.inspect(Evaluator.eval(ast, %{}))
    
    # Test assignment
    {:ok, ast} = RataParser.parse_repl("x = 42")
    IO.puts("x = 42:")
    {:ok, value, context} = Evaluator.eval(ast, %{})
    IO.inspect({value, context})
    
    # Test variable lookup
    {:ok, ast} = RataParser.parse_repl("x")
    IO.puts("x (with x=42 in context):")
    IO.inspect(Evaluator.eval(ast, context))
  end

  def run do
    test_parser()
    test_evaluator()
  end
end

TestRepl.run()