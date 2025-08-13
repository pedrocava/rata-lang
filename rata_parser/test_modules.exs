#!/usr/bin/env elixir

# Simple test to check if all modules can be loaded
IO.puts("Testing module loading...")

try do
  # Add the lib directory to the code path
  Code.prepend_path("lib")

  # Load AST and parser modules
  Code.require_file("lib/rata_parser/ast.ex")
  Code.require_file("lib/rata_parser/lexer.ex") 
  Code.require_file("lib/rata_parser/parser.ex")
  Code.require_file("lib/rata_parser.ex")
  
  # Load all rata modules
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
  
  # Load REPL modules
  Code.require_file("lib/rata_repl/evaluator.ex")
  Code.require_file("lib/rata_repl.ex")

  IO.puts("SUCCESS: All modules loaded successfully!")
  
  # Test basic parser functionality
  result = RataParser.parse("2 + 3")
  IO.puts("Parser test result: #{inspect(result)}")
  
rescue
  e -> 
    IO.puts("ERROR: Failed to load modules")
    IO.puts("Error: #{Exception.message(e)}")
    System.halt(1)
end