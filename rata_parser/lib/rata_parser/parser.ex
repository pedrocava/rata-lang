defmodule RataParser.Parser do
  @moduledoc """
  Parser for the Rata programming language using NimbleParsec.
  
  Parses a stream of tokens into an Abstract Syntax Tree (AST).
  """

  import NimbleParsec
  alias RataParser.AST

  # Forward declarations for recursive rules
  defp expression(combinator \\ empty()), do: pipe_expression(combinator)
  defp statement(combinator \\ empty()), do: choice(combinator, [assignment(), return_statement()])
  defp library_import(combinator \\ empty()), do: parsec(combinator, :library_import)

  # Library import parsing: library ModuleName as alias
  library_import_statement = 
    ignore(tag(:library))
    |> unwrap_and_tag(tag(:identifier), :module_name)
    |> optional(
      ignore(tag(:as))
      |> unwrap_and_tag(tag(:identifier), :alias)
    )
    |> wrap()
    |> map({__MODULE__, :build_library_import, []})

  # Module parsing with optional imports: [imports] module Name { statements }
  module_with_imports = 
    repeat(library_import_statement)
    |> ignore(tag(:module))
    |> unwrap_and_tag(tag(:identifier), :name)
    |> ignore(tag(:left_brace))
    |> repeat(parsec(:statement))
    |> ignore(tag(:right_brace))
    |> reduce({__MODULE__, :build_module_with_imports, []})

  # Module parsing: module Name { statements }
  module_declaration = 
    ignore(tag(:module))
    |> unwrap_and_tag(tag(:identifier), :name)
    |> ignore(tag(:left_brace))
    |> repeat(parsec(:statement))
    |> ignore(tag(:right_brace))
    |> wrap()
    |> map({__MODULE__, :build_module, []})

  # Statement parsing
  assignment = 
    unwrap_and_tag(tag(:identifier), :name)
    |> ignore(tag(:assign))
    |> tag(parsec(:expression), :value)
    |> wrap()
    |> map({__MODULE__, :build_assignment, []})

  return_statement = 
    ignore(tag(:return))
    |> tag(parsec(:expression), :value)
    |> wrap()
    |> map({__MODULE__, :build_return, []})

  # Expression parsing with operator precedence
  
  # Pipe expressions (lowest precedence)
  pipe_expression = 
    parsec(:comparison_expression)
    |> repeat(
      ignore(tag(:pipe))
      |> parsec(:comparison_expression)
    )
    |> reduce({__MODULE__, :build_binary_ops, [:pipe]})

  # Comparison expressions
  comparison_expression = 
    parsec(:additive_expression)
    |> repeat(
      choice([tag(:less_equal), tag(:greater)])
      |> parsec(:additive_expression)
    )
    |> reduce({__MODULE__, :build_binary_ops, [:comparison]})

  # Additive expressions
  additive_expression = 
    parsec(:multiplicative_expression)
    |> repeat(
      choice([tag(:plus), tag(:minus)])
      |> parsec(:multiplicative_expression)
    )
    |> reduce({__MODULE__, :build_binary_ops, [:additive]})

  # Multiplicative expressions  
  multiplicative_expression = 
    parsec(:power_expression)
    |> repeat(
      tag(:multiply)
      |> parsec(:power_expression)
    )
    |> reduce({__MODULE__, :build_binary_ops, [:multiplicative]})

  # Power expressions (right associative)
  power_expression = 
    parsec(:primary_expression)
    |> optional(
      tag(:power)
      |> parsec(:power_expression)
    )
    |> reduce({__MODULE__, :build_right_binary_op, [:power]})

  # Primary expressions
  primary_expression = 
    choice([
      literal(),
      identifier(),
      function_call(),
      function_definition(),
      if_expression(),
      ignore(tag(:left_paren)) |> parsec(:expression) |> ignore(tag(:right_paren))
    ])

  # Literals
  literal = 
    choice([
      unwrap_and_tag(tag(:integer), :value) |> map({__MODULE__, :build_literal, []}),
      unwrap_and_tag(tag(:float), :value) |> map({__MODULE__, :build_literal, []})
    ])

  # Identifiers and qualified identifiers
  qualified_identifier = 
    unwrap_and_tag(tag(:identifier), :module)
    |> ignore(tag(:dot))
    |> unwrap_and_tag(tag(:identifier), :name)
    |> wrap()
    |> map({__MODULE__, :build_qualified_identifier, []})

  identifier = 
    choice([
      qualified_identifier,
      tag(:module_ref) |> map({__MODULE__, :build_module_ref, []}),
      unwrap_and_tag(tag(:identifier), :name) |> map({__MODULE__, :build_identifier, []})
    ])

  # Function calls: expr(args)
  function_call = 
    parsec(:primary_expression)
    |> tag(:left_paren)
    |> optional(
      parsec(:expression)
      |> repeat(
        ignore(tag(:comma))
        |> parsec(:expression)
      )
    )
    |> ignore(tag(:right_paren))
    |> reduce({__MODULE__, :build_function_call, []})

  # Function definitions: function params { body }
  function_definition = 
    ignore(tag(:function))
    |> parsec(:parameter_list)
    |> ignore(tag(:left_brace))
    |> repeat(parsec(:statement))
    |> ignore(tag(:right_brace))
    |> wrap()
    |> map({__MODULE__, :build_function, []})

  # If expressions: if condition { then } else { else }
  if_expression = 
    ignore(tag(:if))
    |> tag(parsec(:expression), :condition)
    |> ignore(tag(:left_brace))
    |> tag(repeat(parsec(:statement)), :then_branch)
    |> ignore(tag(:right_brace))
    |> optional(
      ignore(tag(:else))
      |> ignore(tag(:left_brace))
      |> tag(repeat(parsec(:statement)), :else_branch)
      |> ignore(tag(:right_brace))
    )
    |> wrap()
    |> map({__MODULE__, :build_if, []})

  # Parameter list: name: type, name: type
  parameter_list = 
    unwrap_and_tag(tag(:identifier), :name)
    |> optional(
      ignore(tag(:colon))
      |> unwrap_and_tag(tag(:identifier), :type)
    )
    |> wrap()
    |> repeat(
      ignore(tag(:comma))
      |> unwrap_and_tag(tag(:identifier), :name)
      |> optional(
        ignore(tag(:colon))
        |> unwrap_and_tag(tag(:identifier), :type)
      )
      |> wrap()
    )
    |> reduce({__MODULE__, :build_parameter_list, []})

  # Main parser entry points
  defparsec :parse, module_declaration |> eos()
  defparsec :parse_with_imports, module_with_imports |> eos()
  defparsec :parse_library_import, library_import_statement |> eos()
  defparsec :statement, statement()
  defparsec :expression, expression()
  defparsec :parameter_list, parameter_list
  
  # REPL parser entry point - handles both statements and expressions
  defparsec :repl_parse, choice([statement(), expression()]) |> eos()

  # Helper functions to build AST nodes
  def build_library_import(args) do
    module_name = Keyword.get(args, :module_name)
    alias_name = Keyword.get(args, :alias)
    %AST.LibraryImport{module_name: module_name, alias: alias_name}
  end

  def build_module([{:name, name} | rest]) do
    body = rest |> List.flatten()
    %AST.Module{name: name, body: body}
  end

  def build_module_with_imports([imports | rest]) do
    [{:name, name} | body_parts] = rest
    body = body_parts |> List.flatten()
    %AST.Module{name: name, body: body, imports: imports}
  end

  def build_assignment([{:name, name}, {:value, value}]) do
    %AST.Assignment{name: name, value: value}
  end

  def build_return([{:value, value}]) do
    %AST.Return{value: value}
  end

  def build_literal([{:value, value}]) do
    %AST.Literal{value: value}
  end

  def build_identifier([{:name, name}]) do
    %AST.Identifier{name: name}
  end

  def build_qualified_identifier([{:module, module}, {:name, name}]) do
    %AST.QualifiedIdentifier{module: module, name: name}
  end

  def build_module_ref([{:module_ref, name}]) do
    %AST.Identifier{name: name}
  end

  def build_function_call([func | args]) do
    %AST.FunctionCall{function: func, args: List.flatten(args)}
  end

  def build_function([params, body]) do
    %AST.Function{params: params, body: List.flatten([body])}
  end

  def build_if(args) do
    condition = Keyword.get(args, :condition)
    then_branch = Keyword.get(args, :then_branch, [])
    else_branch = Keyword.get(args, :else_branch)
    %AST.If{condition: condition, then_branch: then_branch, else_branch: else_branch}
  end

  def build_parameter_list(params) do
    Enum.map(params, fn param ->
      name = Keyword.get(param, :name)
      type = Keyword.get(param, :type)
      %AST.Parameter{name: name, type: type}
    end)
  end

  def build_binary_ops([first | rest], _op_type) do
    Enum.chunk_every(rest, 2)
    |> Enum.reduce(first, fn [op, right], left ->
      %AST.BinaryOp{left: left, operator: op, right: right}
    end)
  end

  def build_right_binary_op([left, op, right], _op_type) do
    %AST.BinaryOp{left: left, operator: op, right: right}
  end
  def build_right_binary_op([expr], _op_type), do: expr
end