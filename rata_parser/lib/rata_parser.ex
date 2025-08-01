defmodule RataParser do
  @moduledoc """
  A parser for the Rata programming language.
  
  This module provides the main API for parsing Rata source code into an AST.
  """

  alias RataParser.{Lexer, Parser, AST}

  @doc """
  Parse a Rata source string into an AST.
  
  Tries to parse with imports first, falls back to regular module parsing.
  
  ## Examples
  
      iex> RataParser.parse("module Test { x = 1 }")
      {:ok, %AST.Module{name: "Test", body: [%AST.Assignment{name: "x", value: %AST.Literal{value: 1}}]}}
      
      iex> RataParser.parse("library Foo as f\\nmodule Test { x = f.bar() }")
      {:ok, %AST.Module{name: "Test", imports: [%AST.LibraryImport{module_name: "Foo", alias: "f"}], body: [...]}}
  """
  def parse(source) when is_binary(source) do
    with {:ok, tokens, _, _, _, _} <- Lexer.tokenize(source) do
      # Try parsing with imports first
      case Parser.parse_with_imports(tokens) do
        {:ok, ast, _, _, _, _} -> {:ok, ast}
        # Fall back to regular module parsing
        _error -> 
          case Parser.parse(tokens) do
            {:ok, ast, _, _, _, _} -> {:ok, ast}
            {:error, reason, _, _, _, _} -> {:error, reason}
            error -> error
          end
      end
    else
      {:error, reason, _, _, _, _} -> {:error, reason}
      error -> error
    end
  end

  @doc """
  Parse a REPL input string (statement or expression) into an AST.
  
  ## Examples
  
      iex> RataParser.parse_repl("x = 1")
      {:ok, %AST.Assignment{name: "x", value: %AST.Literal{value: 1}}}
      
      iex> RataParser.parse_repl("2 + 3")
      {:ok, %AST.BinaryOp{left: %AST.Literal{value: 2}, operator: :plus, right: %AST.Literal{value: 3}}}
  """
  def parse_repl(source) when is_binary(source) do
    with {:ok, tokens, _, _, _, _} <- Lexer.tokenize(source),
         {:ok, ast, _, _, _, _} <- Parser.repl_parse(tokens) do
      {:ok, ast}
    else
      {:error, reason, _, _, _, _} -> {:error, reason}
      error -> error
    end
  end
end