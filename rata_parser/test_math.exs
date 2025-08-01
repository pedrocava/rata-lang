#!/usr/bin/env elixir

# Test script for Math module
Mix.install([{:nimble_parsec, "~> 1.4"}])

# Add the lib directory to the code path
Code.prepend_path("lib")

# Load our modules
Code.require_file("lib/rata_parser/ast.ex")
Code.require_file("lib/rata_parser/lexer.ex") 
Code.require_file("lib/rata_parser/parser.ex")
Code.require_file("lib/rata_parser.ex")
Code.require_file("lib/rata_modules/math.ex")
Code.require_file("lib/rata_repl/evaluator.ex")

# Test basic math operations
IO.puts("Testing Math module...")

# Test basic functions
{:ok, result} = RataModules.Math.add(2, 3)
IO.puts("Math.add(2, 3) = #{result}")

{:ok, result} = RataModules.Math.sqrt(16)
IO.puts("Math.sqrt(16) = #{result}")

{:ok, result} = RataModules.Math.power(2, 3)
IO.puts("Math.power(2, 3) = #{result}")

# Test evaluator integration
alias RataRepl.Evaluator
alias RataParser.AST

# Test Math.sqrt(4) evaluation
IO.puts("\nTesting evaluator integration...")

# Create AST for Math.sqrt(4)
math_sqrt_ast = %AST.FunctionCall{
  function: %AST.QualifiedIdentifier{module: "Math", name: "sqrt"},
  args: [%AST.Literal{value: 4}]
}

case Evaluator.eval(math_sqrt_ast, %{}) do
  {:ok, result, _context} -> 
    IO.puts("Math.sqrt(4) via evaluator = #{result}")
  {:error, reason} -> 
    IO.puts("Error: #{reason}")
end

# Test Math.add(2, 3) evaluation
math_add_ast = %AST.FunctionCall{
  function: %AST.QualifiedIdentifier{module: "Math", name: "add"},
  args: [%AST.Literal{value: 2}, %AST.Literal{value: 3}]
}

case Evaluator.eval(math_add_ast, %{}) do
  {:ok, result, _context} -> 
    IO.puts("Math.add(2, 3) via evaluator = #{result}")
  {:error, reason} -> 
    IO.puts("Error: #{reason}")
end

IO.puts("Math module testing complete!")