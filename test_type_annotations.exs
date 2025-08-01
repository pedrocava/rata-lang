#!/usr/bin/env elixir

# Test script to verify type annotations and return statements work

IO.puts("Testing Rata parser with type annotations and return statements...")

# Add the rata_parser lib to the path
Code.prepend_path("rata_parser/lib")

# Test parsing simple function with type annotation
test_code1 = """
module TestModule {
  add1 = function n: int { n + 1 }
}
"""

IO.puts("\n1. Testing function with int type annotation:")
IO.puts(test_code1)

case RataParser.parse(test_code1) do
  {:ok, ast, _} -> 
    IO.puts("✓ Parsed successfully!")
    IO.inspect(ast, pretty: true)
  {:error, reason} -> 
    IO.puts("✗ Parse error: #{reason}")
end

# Test parsing function with return statement
test_code2 = """
module TestModule {
  fibonacci = function n: posint {
    if n <= 2 {
      return 1
    } else {
      return fibonacci(n-1) + fibonacci(n-2)  
    }
  }
}
"""

IO.puts("\n2. Testing function with posint type and return statements:")
IO.puts(test_code2)

case RataParser.parse(test_code2) do
  {:ok, ast, _} -> 
    IO.puts("✓ Parsed successfully!")
    IO.inspect(ast, pretty: true)
  {:error, reason} -> 
    IO.puts("✗ Parse error: #{reason}")
end

# Test parsing function with numeric type
test_code3 = """
module TestModule {
  powerfac = function k: int {
    return function x: numeric { x^k }
  }
}
"""

IO.puts("\n3. Testing nested function with numeric type:")
IO.puts(test_code3)

case RataParser.parse(test_code3) do
  {:ok, ast, _} -> 
    IO.puts("✓ Parsed successfully!")
    IO.inspect(ast, pretty: true)
  {:error, reason} -> 
    IO.puts("✗ Parse error: #{reason}")
end

IO.puts("\n4. Testing the complete example-module.rata:")

# Read and test the actual sample file
case File.read("specs/samples/example-module.rata") do
  {:ok, content} ->
    IO.puts(content)
    case RataParser.parse(content) do
      {:ok, ast, _} -> 
        IO.puts("✓ Complete example parsed successfully!")
        IO.inspect(ast, pretty: true)
      {:error, reason} -> 
        IO.puts("✗ Parse error: #{reason}")
    end
  {:error, reason} ->
    IO.puts("Could not read example file: #{reason}")
end

IO.puts("\nTest completed!")