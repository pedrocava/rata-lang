#!/usr/bin/env elixir

# Script to start the Rata REPL
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
Code.require_file("lib/rata_repl.ex")

# Start the REPL
RataRepl.start()