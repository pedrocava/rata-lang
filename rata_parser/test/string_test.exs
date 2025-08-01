defmodule StringTest do
  use ExUnit.Case
  alias RataParser.{Lexer, Parser}
  alias RataRepl.Evaluator

  describe "Basic string literals" do
    test "tokenizes string literals correctly" do
      {:ok, tokens, "", _, _, _} = Lexer.tokenize(~s("hello world"))
      assert tokens == [{:string, "hello world"}]
    end

    test "parses string literals correctly" do
      {:ok, tokens, "", _, _, _} = Lexer.tokenize(~s("hello world"))
      {:ok, [ast], "", _, _, _} = Parser.repl_parse(tokens)
      
      assert %RataParser.AST.Literal{value: "hello world"} = ast
    end

    test "evaluates string literals correctly" do
      {:ok, tokens, "", _, _, _} = Lexer.tokenize(~s("hello world"))
      {:ok, [ast], "", _, _, _} = Parser.repl_parse(tokens)
      {:ok, result, _} = Evaluator.eval(ast)
      
      assert result == "hello world"
    end

    test "handles escape sequences" do
      {:ok, tokens, "", _, _, _} = Lexer.tokenize(~s("hello\\nworld"))
      {:ok, [ast], "", _, _, _} = Parser.repl_parse(tokens)
      {:ok, result, _} = Evaluator.eval(ast)
      
      assert result == "hello\nworld"
    end
  end

  describe "String concatenation" do
    test "concatenates strings with + operator" do
      {:ok, tokens, "", _, _, _} = Lexer.tokenize(~s("hello" + " world"))
      {:ok, [ast], "", _, _, _} = Parser.repl_parse(tokens)
      {:ok, result, _} = Evaluator.eval(ast)
      
      assert result == "hello world"
    end
  end

  describe "F-string literals" do
    test "tokenizes f-strings correctly" do
      {:ok, tokens, "", _, _, _} = Lexer.tokenize(~s(f"hello {name}"))
      assert [{:f_string, "f\"hello {name}\""}] = tokens
    end

    test "parses simple f-strings correctly" do
      {:ok, tokens, "", _, _, _} = Lexer.tokenize(~s(f"hello {name}"))
      {:ok, [ast], "", _, _, _} = Parser.repl_parse(tokens)
      
      assert %RataParser.AST.InterpolatedString{parts: parts} = ast
      assert length(parts) == 2
      assert "hello " in parts
    end

    test "evaluates f-strings with variables" do
      context = %{"name" => "world"}
      
      {:ok, tokens, "", _, _, _} = Lexer.tokenize(~s(f"hello {name}"))
      {:ok, [ast], "", _, _, _} = Parser.repl_parse(tokens)
      {:ok, result, _} = Evaluator.eval(ast, context)
      
      assert result == "hello world"
    end

    test "evaluates f-strings with expressions" do
      context = %{"x" => 5, "y" => 3}
      
      {:ok, tokens, "", _, _, _} = Lexer.tokenize(~s(f"result: {x + y}"))
      {:ok, [ast], "", _, _, _} = Parser.repl_parse(tokens)
      {:ok, result, _} = Evaluator.eval(ast, context)
      
      assert result == "result: 8"
    end
  end
end