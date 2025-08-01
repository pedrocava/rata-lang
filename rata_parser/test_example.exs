#!/usr/bin/env elixir

# Script to test parsing the example Rata module
Mix.install([{:nimble_parsec, "~> 1.4"}])

defmodule TestRunner do
  def run do
    # Add the lib directory to the code path
    Code.prepend_path("lib")
    
    # Load our parser modules
    Code.require_file("lib/rata_parser/ast.ex")
    Code.require_file("lib/rata_parser/lexer.ex") 
    Code.require_file("lib/rata_parser/parser.ex")
    Code.require_file("lib/rata_parser.ex")

    # Read the example file
    example_path = "../specs/samples/example-module.rata"
    
    case File.read(example_path) do
      {:ok, source} ->
        IO.puts("=== Parsing example-module.rata ===")
        IO.puts("Source:")
        IO.puts(source)
        IO.puts("\n=== Lexer Output ===")
        
        case RataParser.Lexer.tokenize(source) do
          {:ok, tokens, _, _, _, _} ->
            IO.inspect(tokens, pretty: true, limit: :infinity)
            
            IO.puts("\n=== Parser Output ===")
            case RataParser.Parser.parse(tokens) do
              {:ok, ast, _, _, _, _} ->
                IO.puts("Successfully parsed!")
                IO.inspect(ast, pretty: true, limit: :infinity)
                
              {:error, reason} ->
                IO.puts("Parser error: #{inspect(reason)}")
            end
            
          {:error, reason} ->
            IO.puts("Lexer error: #{inspect(reason)}")
        end
        
      {:error, reason} ->
        IO.puts("Could not read example file: #{inspect(reason)}")
    end
  end
end

TestRunner.run()