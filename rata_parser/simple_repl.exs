#!/usr/bin/env elixir

# Simple REPL without Mix.install dependency
# This bypasses the crypto/SSL issues by avoiding nimble_parsec

IO.puts("Simple Rata REPL (without parsing)")
IO.puts("Type 'quit' to exit")
IO.puts("")

defmodule SimpleRepl do
  def loop do
    input = IO.gets("rata> ") |> String.trim()
    
    case input do
      "quit" -> IO.puts("Goodbye!")
      "" -> loop()
      _ -> 
        IO.puts("Input received: #{input}")
        IO.puts("(Parser not available - would need nimble_parsec)")
        loop()
    end
  end
end

SimpleRepl.loop()