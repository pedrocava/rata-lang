defmodule RataParser.Parser do
  @moduledoc """
  Parser for the Rata programming language using NimbleParsec.
  
  Parses a stream of tokens into an Abstract Syntax Tree (AST).
  """

  import NimbleParsec
  alias RataParser.AST

  # Forward declarations for recursive rules
  defp expression(combinator \\ empty()), do: pipe_expression(combinator)
  defp statement(combinator \\ empty()), do: choice(combinator, [assert_statement(), return_statement(), raise_statement(), reraise_statement(), assignment()])
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

  assert_statement = 
    ignore(tag(:assert))
    |> tag(parsec(:expression), :condition)
    |> wrap()
    |> map({__MODULE__, :build_assert, []})

  raise_statement = 
    ignore(tag(:raise))
    |> tag(parsec(:expression), :exception)
    |> optional(
      ignore(tag(:comma))
      |> tag(parsec(:expression), :message)
    )
    |> wrap()
    |> map({__MODULE__, :build_raise, []})

  reraise_statement = 
    ignore(tag(:reraise))
    |> optional(
      tag(parsec(:expression), :exception)
      |> optional(
        ignore(tag(:comma))
        |> tag(parsec(:expression), :stacktrace)
      )
    )
    |> wrap()
    |> map({__MODULE__, :build_reraise, []})

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
      choice([tag(:equal), tag(:not_equal), tag(:less_equal), tag(:greater)])
      |> parsec(:additive_expression)
    )
    |> reduce({__MODULE__, :build_binary_ops, [:comparison]})

  # Additive expressions (includes ranges)  
  additive_expression = 
    parsec(:range_expression)
    |> repeat(
      choice([tag(:plus), tag(:minus)])
      |> parsec(:range_expression)
    )
    |> reduce({__MODULE__, :build_binary_ops, [:additive]})

  # Range expressions
  range_expression = 
    parsec(:multiplicative_expression)
    |> optional(
      tag(:range)
      |> parsec(:multiplicative_expression)
    )
    |> reduce({__MODULE__, :build_range_if_present, []})

  # Multiplicative expressions  
  multiplicative_expression = 
    parsec(:power_expression)
    |> repeat(
      choice([tag(:multiply), tag(:modulo)])
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
      symbol(),
      set(),
      vector(),
      brace_expression(),
      lambda_expression(),
      lambda_parameter(),
      underscore(),
      identifier(),
      function_call(),
      function_definition(),
      if_expression(),
      case_expression(),
      try_expression(),
      ignore(tag(:left_paren)) |> parsec(:expression) |> ignore(tag(:right_paren))
    ])

  # Literals
  literal = 
    choice([
      unwrap_and_tag(tag(:f_string), :content) |> map({__MODULE__, :build_interpolated_string, []}),
      unwrap_and_tag(tag(:string), :value) |> map({__MODULE__, :build_literal, []}),
      unwrap_and_tag(tag(:integer), :value) |> map({__MODULE__, :build_literal, []}),
      unwrap_and_tag(tag(:float), :value) |> map({__MODULE__, :build_literal, []})
    ])

  # Symbols
  symbol = 
    unwrap_and_tag(tag(:symbol), :name) |> map({__MODULE__, :build_symbol, []})

  # Sets
  set = 
    ignore(tag(:set_start))
    |> optional(
      parsec(:expression)
      |> repeat(
        ignore(tag(:comma))
        |> parsec(:expression)
      )
    )
    |> ignore(tag(:right_brace))
    |> reduce({__MODULE__, :build_set, []})

  # Vectors/Lists
  vector = 
    ignore(tag(:left_bracket))
    |> optional(
      parsec(:expression)
      |> repeat(
        ignore(tag(:comma))
        |> parsec(:expression)
      )
    )
    |> ignore(tag(:right_bracket))
    |> reduce({__MODULE__, :build_vector, []})

  # Ranges will be handled in additive expressions for proper precedence

  # Brace expressions - can be either maps or tuples
  # Maps have key: value syntax, tuples are positional
  brace_expression = 
    ignore(tag(:left_brace))
    |> optional(
      choice([
        # Try map syntax first (key: value)
        parsec(:key_value_pair)
        |> repeat(
          ignore(tag(:comma))
          |> parsec(:key_value_pair)
        )
        |> tag(:map_content),
        # Fall back to tuple syntax (positional)
        parsec(:expression)
        |> repeat(
          ignore(tag(:comma))
          |> parsec(:expression)
        )
        |> tag(:tuple_content)
      ])
    )
    |> ignore(tag(:right_brace))
    |> reduce({__MODULE__, :build_brace_expression, []})

  # Key-value pairs for maps
  key_value_pair = 
    parsec(:expression)
    |> ignore(tag(:colon))
    |> parsec(:expression)
    |> wrap()

  # Helper aliases for compatibility
  map = brace_expression
  tuple = brace_expression

  # Lambda expressions: ~ .x + .y
  lambda_expression = 
    ignore(tag(:lambda))
    |> parsec(:expression)
    |> wrap()
    |> map({__MODULE__, :build_lambda, []})

  # Lambda parameters: .x, .y, etc.
  lambda_parameter = 
    unwrap_and_tag(tag(:lambda_param), :name)
    |> map({__MODULE__, :build_lambda_param, []})

  # Underscore wildcard: _
  underscore = 
    tag(:underscore)
    |> map({__MODULE__, :build_underscore, []})

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

  # Try expressions: try { body } catch { clauses } after { cleanup }
  try_expression = 
    ignore(tag(:try))
    |> ignore(tag(:left_brace))
    |> tag(repeat(parsec(:statement)), :body)
    |> ignore(tag(:right_brace))
    |> optional(
      choice([
        # catch as variable { clauses }
        ignore(tag(:catch))
        |> ignore(tag(:as))
        |> unwrap_and_tag(tag(:identifier), :exception_var)
        |> ignore(tag(:left_brace))
        |> tag(repeat(parsec(:catch_clause)), :catch_clauses)
        |> ignore(tag(:right_brace))
        |> wrap(),
        # catch { clauses }
        ignore(tag(:catch))
        |> ignore(tag(:left_brace))
        |> tag(repeat(parsec(:catch_clause)), :catch_clauses)
        |> ignore(tag(:right_brace))
        |> wrap()
      ])
    )
    |> optional(
      ignore(tag(:else))
      |> ignore(tag(:left_brace))
      |> tag(repeat(parsec(:statement)), :else_clause)
      |> ignore(tag(:right_brace))
    )
    |> optional(
      ignore(tag(:after))
      |> ignore(tag(:left_brace))
      |> tag(repeat(parsec(:statement)), :after_clause)
      |> ignore(tag(:right_brace))
    )
    |> wrap()
    |> map({__MODULE__, :build_try, []})

  # Catch clauses: pattern -> body
  catch_clause = 
    tag(parsec(:pattern), :pattern)
    |> optional(
      ignore(tag(:when))
      |> tag(parsec(:expression), :guard)
    )
    |> ignore(tag(:arrow))
    |> tag(repeat(parsec(:statement)), :body)
    |> wrap()
    |> map({__MODULE__, :build_catch_clause, []})

  # Parameter list: name: type, name: type
  # Type can be an identifier or a built-in type keyword
  type_annotation = 
    choice([
      tag(:posint),
      tag(:numeric), 
      tag(:int),
      tag(:string),
      tag(:bool),
      tag(:identifier)
    ])

  parameter_list = 
    unwrap_and_tag(tag(:identifier), :name)
    |> optional(
      ignore(tag(:colon))
      |> unwrap_and_tag(type_annotation, :type)
    )
    |> wrap()
    |> repeat(
      ignore(tag(:comma))
      |> unwrap_and_tag(tag(:identifier), :name)
      |> optional(
        ignore(tag(:colon))
        |> unwrap_and_tag(type_annotation, :type)
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
  defparsec :key_value_pair, key_value_pair
  defparsec :catch_clause, catch_clause
  defparsec :pattern, pattern
  defparsec :tuple_pattern, tuple_pattern
  defparsec :symbol_pattern, symbol_pattern
  defparsec :literal_pattern, literal_pattern
  defparsec :identifier_pattern, identifier_pattern
  defparsec :wildcard_pattern, wildcard_pattern
  defparsec :case_clause, case_clause
  
  # REPL parser entry point - handles both statements and expressions
  defparsec :repl_parse, choice([statement(), expression()]) |> eos()

  # Pattern parsing for case expressions and catch clauses
  pattern = 
    choice([
      parsec(:tuple_pattern),
      parsec(:symbol_pattern),
      parsec(:literal_pattern),
      parsec(:identifier_pattern),
      parsec(:wildcard_pattern)
    ])

  # Tuple patterns: {:ok, value}, {:error, message}
  tuple_pattern = 
    ignore(tag(:left_brace))
    |> optional(
      parsec(:pattern)
      |> repeat(
        ignore(tag(:comma))
        |> parsec(:pattern)
      )
    )
    |> ignore(tag(:right_brace))
    |> reduce({__MODULE__, :build_tuple_pattern, []})

  # Symbol patterns: :ok, :error
  symbol_pattern = 
    unwrap_and_tag(tag(:symbol), :name)
    |> map({__MODULE__, :build_symbol_pattern, []})

  # Literal patterns: 42, "hello"
  literal_pattern = 
    choice([
      unwrap_and_tag(tag(:integer), :value) |> map({__MODULE__, :build_literal_pattern, []}),
      unwrap_and_tag(tag(:float), :value) |> map({__MODULE__, :build_literal_pattern, []}),
      unwrap_and_tag(tag(:string), :value) |> map({__MODULE__, :build_literal_pattern, []})
    ])

  # Identifier patterns (variable bindings): x, value
  identifier_pattern = 
    unwrap_and_tag(tag(:identifier), :name)
    |> map({__MODULE__, :build_identifier_pattern, []})

  # Wildcard patterns: _
  wildcard_pattern = 
    tag(:underscore)
    |> map({__MODULE__, :build_wildcard_pattern, []})

  # Case clauses: pattern -> expression or pattern when guard -> expression
  case_clause = 
    parsec(:pattern)
    |> optional(
      ignore(tag(:when))
      |> parsec(:expression)
      |> unwrap_and_tag(:guard)
    )
    |> ignore(tag(:arrow))
    |> parsec(:expression)
    |> reduce({__MODULE__, :build_case_clause, []})

  # Case expressions: case value { pattern -> result, pattern -> result }
  case_expression = 
    ignore(tag(:case))
    |> parsec(:expression)
    |> ignore(tag(:left_brace))
    |> optional(
      parsec(:case_clause)
      |> repeat(
        ignore(tag(:comma))
        |> parsec(:case_clause)
      )
    )
    |> ignore(tag(:right_brace))
    |> reduce({__MODULE__, :build_case_expression, []})

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

  def build_assert([{:condition, condition}]) do
    %AST.AssertStatement{condition: condition}
  end

  def build_raise([{:exception, exception}]) do
    %AST.RaiseStatement{exception: exception, message: nil}
  end
  def build_raise([{:exception, exception}, {:message, message}]) do
    %AST.RaiseStatement{exception: exception, message: message}
  end

  def build_reraise([]) do
    %AST.ReraisStatement{exception: nil, stacktrace: nil}
  end
  def build_reraise([{:exception, exception}]) do
    %AST.ReraisStatement{exception: exception, stacktrace: nil}
  end
  def build_reraise([{:exception, exception}, {:stacktrace, stacktrace}]) do
    %AST.ReraisStatement{exception: exception, stacktrace: stacktrace}
  end

  def build_try(args) do
    body = Keyword.get(args, :body, [])
    catch_clauses = Keyword.get(args, :catch_clauses, [])
    else_clause = Keyword.get(args, :else_clause)
    after_clause = Keyword.get(args, :after_clause)
    exception_var = Keyword.get(args, :exception_var)
    %AST.TryExpression{body: body, catch_clauses: catch_clauses, else_clause: else_clause, after_clause: after_clause, exception_var: exception_var}
  end

  def build_catch_clause([{:pattern, pattern}, {:body, body}]) do
    %AST.CatchClause{pattern: pattern, guard: nil, body: body}
  end
  def build_catch_clause([{:pattern, pattern}, {:guard, guard}, {:body, body}]) do
    %AST.CatchClause{pattern: pattern, guard: guard, body: body}
  end

  def build_literal([{:value, value}]) do
    %AST.Literal{value: value}
  end

  def build_symbol([{:name, name}]) do
    %AST.Symbol{name: name}
  end

  def build_set(elements) do
    %AST.Set{elements: List.flatten(elements)}
  end

  def build_vector(elements) do
    %AST.Vector{elements: List.flatten(elements)}
  end

  def build_range([start, :range, end_expr]) do
    %AST.Range{start: start, end: end_expr}
  end

  def build_range_if_present([start, :range, end_expr]) do
    %AST.Range{start: start, end: end_expr}
  end
  def build_range_if_present([expr]), do: expr

  def build_brace_expression([]) do
    # Empty braces default to empty tuple
    %AST.Tuple{elements: []}
  end

  def build_brace_expression([{:map_content, pairs}]) do
    # Convert wrapped key-value pairs to tuples
    converted_pairs = Enum.map(pairs, fn [key, value] -> {key, value} end)
    %AST.Map{pairs: converted_pairs}
  end

  def build_brace_expression([{:tuple_content, elements}]) do
    %AST.Tuple{elements: List.flatten(elements)}
  end

  def build_map(pairs) do
    # Convert wrapped pairs to tuples
    converted_pairs = Enum.map(pairs, fn [key, value] -> {key, value} end)
    %AST.Map{pairs: converted_pairs}
  end

  def build_tuple(elements) do
    %AST.Tuple{elements: List.flatten(elements)}
  end

  def build_lambda([body]) do
    # Extract lambda parameters from the body expression during parsing
    params = extract_lambda_params(body)
    %AST.Lambda{body: body, params: params}
  end

  def build_lambda_param([{:name, name}]) do
    %AST.LambdaParam{name: name}
  end

  def build_underscore([_]) do
    %AST.Underscore{}
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
      type = case Keyword.get(param, :type) do
        nil -> nil
        atom when is_atom(atom) -> Atom.to_string(atom)
        string when is_binary(string) -> string
      end
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

  def build_interpolated_string([{:content, f_string_content}]) do
    parts = parse_f_string_content(f_string_content)
    %AST.InterpolatedString{parts: parts}
  end

  # Helper function to parse f-string content and extract parts
  defp parse_f_string_content(content) do
    # Remove the f" and " from the content
    inner_content = String.slice(content, 2..-2)
    
    # Split into parts - this is a simplified implementation
    # In a full implementation, we'd need a proper parser for nested expressions
    parse_f_string_parts(inner_content, [], "")
  end

  defp parse_f_string_parts("", parts, current_string) do
    if current_string != "" do
      parts ++ [current_string]
    else
      parts
    end
  end

  defp parse_f_string_parts("{" <> rest, parts, current_string) do
    # Find matching closing brace
    case find_closing_brace(rest, 0) do
      {expr_content, remaining} ->
        # Parse the expression content using the full expression parser
        expr_content_trimmed = String.trim(expr_content)
        expr_ast = case parse_f_string_expression(expr_content_trimmed) do
          {:ok, ast} -> ast
          {:error, _} -> %AST.Identifier{name: expr_content_trimmed}  # Fallback to identifier
        end
        new_parts = if current_string != "", do: parts ++ [current_string, expr_ast], else: parts ++ [expr_ast]
        parse_f_string_parts(remaining, new_parts, "")
      :no_match ->
        # Treat as literal brace
        parse_f_string_parts(rest, parts, current_string <> "{")
    end
  end

  defp parse_f_string_parts(<<char::utf8, rest::binary>>, parts, current_string) do
    parse_f_string_parts(rest, parts, current_string <> <<char::utf8>>)
  end

  defp find_closing_brace(content, depth) do
    find_closing_brace(content, depth, "")
  end

  defp find_closing_brace("", _depth, _acc), do: :no_match
  
  defp find_closing_brace("{" <> rest, depth, acc) do
    find_closing_brace(rest, depth + 1, acc <> "{")
  end
  
  defp find_closing_brace("}" <> rest, 0, acc) do
    {acc, rest}
  end
  
  defp find_closing_brace("}" <> rest, depth, acc) do
    find_closing_brace(rest, depth - 1, acc <> "}")
  end
  
  defp find_closing_brace(<<char::utf8, rest::binary>>, depth, acc) do
    find_closing_brace(rest, depth, acc <> <<char::utf8>>)
  end

  # Helper function to parse expressions inside f-strings
  defp parse_f_string_expression(expr_content) do
    with {:ok, tokens} <- RataParser.Lexer.tokenize(expr_content),
         {:ok, [ast], "", _, _, _} <- expression(tokens) do
      {:ok, ast}
    else
      _ -> {:error, :parse_failed}
    end
  end

  # Helper functions for building pattern AST nodes
  def build_tuple_pattern([]), do: %AST.TuplePattern{elements: []}
  def build_tuple_pattern(elements), do: %AST.TuplePattern{elements: elements}

  def build_symbol_pattern([name: name]), do: %AST.SymbolPattern{name: name}

  def build_literal_pattern([value: value]), do: %AST.LiteralPattern{value: value}

  def build_identifier_pattern([name: name]), do: %AST.IdentifierPattern{name: name}

  def build_wildcard_pattern(_), do: %AST.WildcardPattern{}

  def build_case_clause([pattern, guard: guard, expression]) do
    %AST.CaseClause{pattern: pattern, guard: guard, body: expression}
  end

  def build_case_clause([pattern, expression]) do
    %AST.CaseClause{pattern: pattern, guard: nil, body: expression}
  end

  def build_case_expression([subject]), do: %AST.CaseExpression{subject: subject, clauses: []}
  def build_case_expression([subject | clauses]), do: %AST.CaseExpression{subject: subject, clauses: clauses}

  # Helper function to extract lambda parameters from an expression
  defp extract_lambda_params(%AST.LambdaParam{name: name}), do: [name]
  defp extract_lambda_params(%AST.BinaryOp{left: left, right: right}) do
    extract_lambda_params(left) ++ extract_lambda_params(right)
  end
  defp extract_lambda_params(%AST.FunctionCall{function: func, args: args}) do
    extract_lambda_params(func) ++ Enum.flat_map(args, &extract_lambda_params/1)
  end
  defp extract_lambda_params(%AST.If{condition: cond, then_branch: then_b, else_branch: else_b}) do
    cond_params = extract_lambda_params(cond)
    then_params = Enum.flat_map(then_b, &extract_lambda_params/1)
    else_params = if else_b, do: Enum.flat_map(else_b, &extract_lambda_params/1), else: []
    cond_params ++ then_params ++ else_params
  end
  defp extract_lambda_params(_), do: []
end