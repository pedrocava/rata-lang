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
  end

  describe "error handling" do
    test "handles invalid library syntax" do
      assert {:error, _} = RataParser.parse("library")
      assert {:error, _} = RataParser.parse("library as em")  
      assert {:error, _} = RataParser.parse("library ExampleModule as")
    end
  end
end