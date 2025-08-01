defmodule LambdaTest do
  use ExUnit.Case
  
  alias RataParser.{Lexer, Parser, AST}
  alias RataRepl.Evaluator

  describe "lambda evaluation" do
    test "evaluates simple lambda expression" do
      # ~ .x + 1
      lambda = %AST.Lambda{
        body: %AST.BinaryOp{
          left: %AST.LambdaParam{name: "x"},
          operator: :plus,
          right: %AST.Literal{value: 1}
        },
        params: ["x"]
      }
      
      assert {:ok, {:lambda, _body, ["x"]}, %{}} = Evaluator.eval(lambda, %{})
    end

    test "evaluates lambda parameter in context" do
      context = %{"__lambda_x" => 5}
      param = %AST.LambdaParam{name: "x"}
      
      assert {:ok, 5, ^context} = Evaluator.eval(param, context)
    end

    test "errors on undefined lambda parameter" do
      param = %AST.LambdaParam{name: "x"}
      
      assert {:error, "undefined lambda parameter: .x"} = Evaluator.eval(param, %{})
    end

    test "evaluates lambda function call" do
      # Create lambda: ~ .x + 1
      lambda_body = %AST.BinaryOp{
        left: %AST.LambdaParam{name: "x"},
        operator: :plus,
        right: %AST.Literal{value: 1}
      }
      
      # Function call with lambda
      func_call = %AST.FunctionCall{
        function: %AST.Lambda{body: lambda_body, params: ["x"]},
        args: [%AST.Literal{value: 5}]
      }
      
      assert {:ok, 6, %{}} = Evaluator.eval(func_call, %{})
    end

    test "evaluates two-parameter lambda" do
      # Create lambda: ~ .x + .y
      lambda_body = %AST.BinaryOp{
        left: %AST.LambdaParam{name: "x"},
        operator: :plus,
        right: %AST.LambdaParam{name: "y"}
      }
      
      # Function call with lambda
      func_call = %AST.FunctionCall{
        function: %AST.Lambda{body: lambda_body, params: ["x", "y"]},
        args: [%AST.Literal{value: 3}, %AST.Literal{value: 4}]
      }
      
      assert {:ok, 7, %{}} = Evaluator.eval(func_call, %{})
    end

    test "errors on parameter count mismatch" do
      lambda_body = %AST.BinaryOp{
        left: %AST.LambdaParam{name: "x"},
        operator: :plus,
        right: %AST.LambdaParam{name: "y"}
      }
      
      # Function call with wrong number of args
      func_call = %AST.FunctionCall{
        function: %AST.Lambda{body: lambda_body, params: ["x", "y"]},
        args: [%AST.Literal{value: 5}]  # Only one arg, expected two
      }
      
      assert {:error, "lambda parameter count mismatch: expected 2, got 1"} = 
        Evaluator.eval(func_call, %{})
    end
  end

  describe "lambda integration" do
    test "parses and evaluates lambda from source" do
      source = "~ .x * .x"
      
      # Tokenize
      assert {:ok, tokens, "", %{}, _, _} = Lexer.tokenize(source)
      
      # Parse expression
      assert {:ok, ast, "", %{}, _, _} = Parser.repl_parse(tokens)
      
      # Should be a lambda
      assert %AST.Lambda{params: ["x"]} = ast
      
      # Evaluate as function call
      func_call = %AST.FunctionCall{
        function: ast,
        args: [%AST.Literal{value: 4}]
      }
      
      assert {:ok, 16, %{}} = Evaluator.eval(func_call, %{})
    end
  end
end