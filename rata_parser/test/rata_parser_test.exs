defmodule RataParserTest do
  use ExUnit.Case
  doctest RataParser

  alias RataParser.{Lexer, Parser, AST}

  describe "lexer" do
    test "tokenizes simple integers" do
      assert {:ok, [integer: 42], "", %{}, {1, 0}, 2} = Lexer.tokenize("42")
    end

    test "tokenizes floats" do
      assert {:ok, [float: 3.14], "", %{}, {1, 0}, 4} = Lexer.tokenize("3.14")
    end

    test "tokenizes keywords" do
      assert {:ok, [:module, :function, :if, :else, :return], "", %{}, {1, 0}, 28} = 
               Lexer.tokenize("module function if else return")
    end

    test "tokenizes identifiers" do
      assert {:ok, [identifier: "test", identifier: "var123"], "", %{}, {1, 0}, 11} = 
               Lexer.tokenize("test var123")
    end

    test "tokenizes operators" do
      assert {:ok, [:assign, :plus, :minus, :multiply, :power, :less_equal, :greater, :pipe], "", %{}, {1, 0}, 15} = 
               Lexer.tokenize("= + - * ^ <= > \\>")
    end

    test "tokenizes module reference" do
      assert {:ok, [module_ref: "__module__"], "", %{}, {1, 0}, 10} = 
               Lexer.tokenize("__module__")
    end

    test "tokenizes symbols" do
      assert {:ok, [symbol: "ok"], "", %{}, {1, 0}, 3} = 
               Lexer.tokenize(":ok")
      assert {:ok, [symbol: "error"], "", %{}, {1, 0}, 6} = 
               Lexer.tokenize(":error")
      assert {:ok, [symbol: "info_123"], "", %{}, {1, 0}, 9} = 
               Lexer.tokenize(":info_123")
    end

    test "tokenizes tuple delimiters" do
      assert {:ok, [:left_brace, :right_brace], "", %{}, {1, 0}, 2} = 
               Lexer.tokenize("{}")
    end

    test "tokenizes library import keywords" do
      assert {:ok, [:library, {:identifier, "ExampleModule"}, :as, {:identifier, "em"}], "", %{}, {1, 0}, _} = 
               Lexer.tokenize("library ExampleModule as em")
    end

    test "tokenizes library without alias" do
      assert {:ok, [:library, {:identifier, "MyModule"}], "", %{}, {1, 0}, _} = 
               Lexer.tokenize("library MyModule")
    end

    test "ignores comments and whitespace" do
      source = """
      # This is a comment
      module Test {
        # Another comment  
        x = 1
      }
      """
      
      assert {:ok, tokens, "", %{}, _, _} = Lexer.tokenize(source)
      assert tokens == [
        :module, 
        {:identifier, "Test"}, 
        :left_brace, 
        {:identifier, "x"}, 
        :assign, 
        {:integer, 1}, 
        :right_brace
      ]
    end
  end

  describe "parser" do
    test "parses simple module with assignment" do
      tokens = [:module, {:identifier, "Test"}, :left_brace, {:identifier, "x"}, :assign, {:integer, 1}, :right_brace]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse(tokens)
      assert %AST.Module{
        name: "Test",
        body: [%AST.Assignment{name: "x", value: %AST.Literal{value: 1}}]
      } = ast
    end

    test "parses function assignment" do
      tokens = [
        :module, {:identifier, "Test"}, :left_brace,
        {:identifier, "add1"}, :assign, :function, {:identifier, "n"}, :colon, {:identifier, "int"},
        :left_brace, :return, {:identifier, "n"}, :plus, {:integer, 1}, :right_brace,
        :right_brace
      ]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse(tokens)
      assert %AST.Module{name: "Test", body: [assignment]} = ast
      assert %AST.Assignment{
        name: "add1",
        value: %AST.Function{
          params: [%AST.Parameter{name: "n", type: "int"}],
          body: [%AST.Return{value: %AST.BinaryOp{left: %AST.Identifier{name: "n"}, operator: :plus, right: %AST.Literal{value: 1}}}]
        }
      } = assignment
    end

    test "parses if expressions" do
      tokens = [
        :module, {:identifier, "Test"}, :left_brace,
        :if, {:identifier, "x"}, :greater, {:integer, 0}, :left_brace,
        :return, {:integer, 1}, :right_brace, :else, :left_brace,
        :return, {:integer, 0}, :right_brace,
        :right_brace
      ]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse(tokens)
      assert %AST.Module{body: [if_expr]} = ast
      assert %AST.If{
        condition: %AST.BinaryOp{operator: :greater},
        then_branch: [%AST.Return{value: %AST.Literal{value: 1}}],
        else_branch: [%AST.Return{value: %AST.Literal{value: 0}}]
      } = if_expr
    end

    test "parses function calls" do
      tokens = [
        :module, {:identifier, "Test"}, :left_brace,
        {:identifier, "result"}, :assign, {:identifier, "func"}, :left_paren, {:integer, 1}, :comma, {:integer, 2}, :right_paren,
        :right_brace
      ]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse(tokens)
      assert %AST.Module{body: [assignment]} = ast
      assert %AST.Assignment{
        value: %AST.FunctionCall{
          function: %AST.Identifier{name: "func"},
          args: [%AST.Literal{value: 1}, %AST.Literal{value: 2}]
        }
      } = assignment
    end

    test "parses pipe expressions" do
      tokens = [
        :module, {:identifier, "Test"}, :left_brace,
        {:identifier, "result"}, :assign, {:integer, 8}, :pipe, {:identifier, "square"}, :left_paren, :right_paren,
        :right_brace
      ]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse(tokens)
      assert %AST.Module{body: [assignment]} = ast
      assert %AST.Assignment{
        value: %AST.BinaryOp{
          left: %AST.Literal{value: 8},
          operator: :pipe,
          right: %AST.FunctionCall{function: %AST.Identifier{name: "square"}, args: []}
        }
      } = assignment
    end

    test "parses symbols" do
      tokens = [
        :module, {:identifier, "Test"}, :left_brace,
        {:identifier, "status"}, :assign, {:symbol, "ok"},
        :right_brace
      ]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse(tokens)
      assert %AST.Module{body: [assignment]} = ast
      assert %AST.Assignment{
        name: "status",
        value: %AST.Symbol{name: "ok"}
      } = assignment
    end

    test "parses empty tuples" do
      tokens = [
        :module, {:identifier, "Test"}, :left_brace,
        {:identifier, "empty"}, :assign, :left_brace, :right_brace,
        :right_brace
      ]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse(tokens)
      assert %AST.Module{body: [assignment]} = ast
      assert %AST.Assignment{
        name: "empty",
        value: %AST.Tuple{elements: []}
      } = assignment
    end

    test "parses tuples with elements" do
      tokens = [
        :module, {:identifier, "Test"}, :left_brace,
        {:identifier, "result"}, :assign, :left_brace, {:symbol, "ok"}, :comma, {:integer, 42}, :right_brace,
        :right_brace
      ]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse(tokens)
      assert %AST.Module{body: [assignment]} = ast
      assert %AST.Assignment{
        name: "result",
        value: %AST.Tuple{
          elements: [
            %AST.Symbol{name: "ok"},
            %AST.Literal{value: 42}
          ]
        }
      } = assignment
    end

    test "parses nested tuples" do
      tokens = [
        :module, {:identifier, "Test"}, :left_brace,
        {:identifier, "nested"}, :assign, :left_brace, {:symbol, "ok"}, :comma, 
        :left_brace, {:integer, 1}, :comma, {:integer, 2}, :right_brace, :right_brace,
        :right_brace
      ]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse(tokens)
      assert %AST.Module{body: [assignment]} = ast
      assert %AST.Assignment{
        name: "nested",
        value: %AST.Tuple{
          elements: [
            %AST.Symbol{name: "ok"},
            %AST.Tuple{elements: [%AST.Literal{value: 1}, %AST.Literal{value: 2}]}
          ]
        }
      } = assignment
    end
  end

  describe "library imports" do
    test "parses library import with alias" do
      tokens = [:library, {:identifier, "ExampleModule"}, :as, {:identifier, "em"}]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse_library_import(tokens)
      assert %AST.LibraryImport{
        module_name: "ExampleModule",
        alias: "em"
      } = ast
    end

    test "parses library import without alias" do
      tokens = [:library, {:identifier, "MyModule"}]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse_library_import(tokens)
      assert %AST.LibraryImport{
        module_name: "MyModule", 
        alias: nil
      } = ast
    end

    test "parses module with library import" do
      tokens = [
        :library, {:identifier, "ExampleModule"}, :as, {:identifier, "em"},
        :module, {:identifier, "Test"}, :left_brace,
        {:identifier, "x"}, :assign, {:integer, 1},
        :right_brace
      ]
      
      assert {:ok, ast, "", %{}, _, _} = Parser.parse_with_imports(tokens)
      assert %AST.Module{
        imports: [%AST.LibraryImport{module_name: "ExampleModule", alias: "em"}],
        name: "Test",
        body: [%AST.Assignment{name: "x", value: %AST.Literal{value: 1}}]
      } = ast
    end
  end

  describe "integration" do
    test "end-to-end parsing" do
      source = """
      module Test {
        x = 42
        add1 = function n: int { n + 1 }
      }
      """
      
      assert {:ok, ast} = RataParser.parse(source)
      assert %AST.Module{
        name: "Test",
        body: [
          %AST.Assignment{name: "x", value: %AST.Literal{value: 42}},
          %AST.Assignment{name: "add1", value: %AST.Function{}}
        ]
      } = ast
    end

    test "parses library import with module" do
      source = """
      library ExampleModule as em
      
      module Test {
        result = em.fibonacci(5)
      }
      """
      
      assert {:ok, ast} = RataParser.parse(source)
      assert %AST.Module{
        imports: [%AST.LibraryImport{module_name: "ExampleModule", alias: "em"}],
        name: "Test",
        body: [%AST.Assignment{
          name: "result",
          value: %AST.FunctionCall{
            function: %AST.QualifiedIdentifier{module: "em", name: "fibonacci"},
            args: [%AST.Literal{value: 5}]
          }
        }]
      } = ast
    end

    test "parses example-tests.rata structure" do
      source = """
      library ExampleModule as em

      module "ExampleModuleTests" {
        assert em.fibonacci(1) == 1
      }
      """
      
      assert {:ok, ast} = RataParser.parse(source)
      assert %AST.Module{
        imports: [%AST.LibraryImport{}],
        name: "ExampleModuleTests"
      } = ast
    end

    test "end-to-end parsing with symbols and tuples" do
      source = """
      module Test {
        status = :ok
        result = {:ok, 42}
        error_case = {:error, "something went wrong"}
        nested = {:ok, {1, 2, 3}}
      }
      """
      
      assert {:ok, ast} = RataParser.parse(source)
      assert %AST.Module{
        name: "Test",
        body: [
          %AST.Assignment{name: "status", value: %AST.Symbol{name: "ok"}},
          %AST.Assignment{name: "result", value: %AST.Tuple{elements: [%AST.Symbol{name: "ok"}, %AST.Literal{value: 42}]}},
          %AST.Assignment{name: "error_case", value: %AST.Tuple{elements: [%AST.Symbol{name: "error"}, _]}},
          %AST.Assignment{name: "nested", value: %AST.Tuple{elements: [%AST.Symbol{name: "ok"}, %AST.Tuple{}]}}
        ]
      } = ast
    end

    test "parses tuples in function calls" do
      source = """
      module Test {
        result = process({:ok, data})
      }
      """
      
      assert {:ok, ast} = RataParser.parse(source)
      assert %AST.Module{
        body: [
          %AST.Assignment{
            value: %AST.FunctionCall{
              function: %AST.Identifier{name: "process"},
              args: [%AST.Tuple{elements: [%AST.Symbol{name: "ok"}, %AST.Identifier{name: "data"}]}]
            }
          }
        ]
      } = ast
    end
  end

  describe "error handling" do
    test "handles invalid library syntax" do
      assert {:error, _} = RataParser.parse("library")
      assert {:error, _} = RataParser.parse("library as em")  
      assert {:error, _} = RataParser.parse("library ExampleModule as")
    end
  end
end