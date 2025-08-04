defmodule RataRepl.Evaluator do
  @moduledoc """
  Evaluator for Rata AST nodes in REPL context.
  
  Provides basic evaluation of expressions, assignments, and function calls
  while maintaining session state for variables.
  """

  alias RataParser.AST
  alias RataModules.Math
  alias RataModules.Core

  @doc """
  Evaluate an AST node in the given context.
  
  Returns {:ok, value, new_context} on success or {:error, reason} on failure.
  """
  def eval(ast, context \\ %{})

  # Literals - return their value directly
  def eval(%AST.Literal{value: value}, context) do
    {:ok, value, context}
  end

  # Interpolated strings - evaluate embedded expressions and concatenate
  def eval(%AST.InterpolatedString{parts: parts}, context) do
    case eval_f_string_parts(parts, context, []) do
      {:ok, evaluated_parts, final_context} ->
        result = Enum.join(evaluated_parts, "")
        {:ok, result, final_context}
      error -> error
    end
  end

  # Identifiers - look up in context
  def eval(%AST.Identifier{name: name}, context) do
    case Map.get(context, name) do
      nil -> {:error, "undefined variable: #{name}"}
      value -> {:ok, value, context}
    end
  end

  # Qualified identifiers - handle module.function references
  def eval(%AST.QualifiedIdentifier{module: module_name, name: function_name}, context) do
    case resolve_module_function(module_name, function_name) do
      {:ok, function} -> {:ok, function, context}
      error -> error
    end
  end

  # Assignments - evaluate value and store in context
  def eval(%AST.Assignment{name: name, value: value_ast}, context) do
    case eval(value_ast, context) do
      {:ok, value, updated_context} ->
        new_context = Map.put(updated_context, name, value)
        {:ok, value, new_context}
      error -> error
    end
  end

  # Binary operations
  def eval(%AST.BinaryOp{left: left_ast, operator: op, right: right_ast}, context) do
    with {:ok, left_val, context1} <- eval(left_ast, context),
         {:ok, right_val, context2} <- eval(right_ast, context1) do
      case apply_binary_op(op, left_val, right_val) do
        {:ok, result} -> {:ok, result, context2}
        error -> error
      end
    end
  end

  # Function calls - handle both regular and module function calls
  def eval(%AST.FunctionCall{function: func_ast, args: args_ast}, context) do
    with {:ok, func, context1} <- eval(func_ast, context),
         {:ok, args, final_context} <- eval_args(args_ast, context1) do
      case func do
        {module, function_name} when is_atom(module) and is_atom(function_name) ->
          # Module function call
          case apply(module, function_name, args) do
            {:ok, result} -> {:ok, result, final_context}
            {:error, reason} -> {:error, reason}
            result -> {:ok, result, final_context}  # Handle direct returns
          end
        {:lambda, body, params} ->
          # Lambda function call - bind parameters and evaluate body
          call_lambda(body, params, args, final_context)
        {:function, params, body} ->
          # Regular function call - bind parameters and evaluate body with return handling
          call_function(params, body, args, final_context)
        _ ->
          {:error, "unsupported function type: #{inspect(func)}"}
      end
    end
  end

  # Functions - return as closure with params and body
  def eval(%AST.Function{params: params, body: body}, context) do
    function_closure = {:function, params, body}
    {:ok, function_closure, context}
  end

  # Lambda expressions - return as closure with body and params
  def eval(%AST.Lambda{body: body, params: params}, context) do
    lambda_func = {:lambda, body, params}
    {:ok, lambda_func, context}
  end

  # Lambda parameters - look up in lambda evaluation context
  def eval(%AST.LambdaParam{name: name}, context) do
    case Map.get(context, "__lambda_#{name}") do
      nil -> {:error, "undefined lambda parameter: .#{name}"}
      value -> {:ok, value, context}
    end
  end

  # Return statements - evaluate the value and mark as return
  def eval(%AST.Return{value: value_ast}, context) do
    case eval(value_ast, context) do
      {:ok, value, new_context} -> {:return, value, new_context}
      error -> error
    end
  end

  # If expressions - evaluate condition and execute appropriate branch
  def eval(%AST.If{condition: cond, then_branch: then_branch, else_branch: else_branch}, context) do
    case eval(cond, context) do
      {:ok, condition_value, context1} ->
        if is_truthy(condition_value) do
          eval_function_body(then_branch, context1)
        else
          case else_branch do
            nil -> {:ok, nil, context1}
            else_stmts -> eval_function_body(else_stmts, context1)
          end
        end
      error -> error
    end
  end

  # Sets - create MapSet from evaluated elements
  def eval(%AST.Set{elements: elements}, context) do
    case eval_list(elements, context) do
      {:ok, values, final_context} ->
        set = MapSet.new(values)
        {:ok, set, final_context}
      error -> error
    end
  end

  # Vectors - create list from evaluated elements
  def eval(%AST.Vector{elements: elements}, context) do
    case eval_list(elements, context) do
      {:ok, values, final_context} ->
        {:ok, values, final_context}
      error -> error
    end
  end

  # Ranges - create Elixir Range from evaluated start and end
  def eval(%AST.Range{start: start_ast, end: end_ast}, context) do
    with {:ok, start_val, context1} <- eval(start_ast, context),
         {:ok, end_val, context2} <- eval(end_ast, context1) do
      case {start_val, end_val} do
        {start, end_val} when is_integer(start) and is_integer(end_val) ->
          range = Range.new(start, end_val)
          {:ok, range, context2}
        _ ->
          {:error, "range bounds must be integers"}
      end
    end
  end

  # Maps - create Elixir Map from evaluated key-value pairs
  def eval(%AST.Map{pairs: pairs}, context) do
    case eval_map_pairs(pairs, context, []) do
      {:ok, evaluated_pairs, final_context} ->
        map = Map.new(evaluated_pairs)
        {:ok, map, final_context}
      error -> error
    end
  end

  # Tuples - keep existing implementation but ensure it's handled
  def eval(%AST.Tuple{elements: elements}, context) do
    case eval_list(elements, context) do
      {:ok, values, final_context} ->
        tuple = List.to_tuple(values)
        {:ok, tuple, final_context}
      error -> error
    end
  end

  # Symbols - keep existing implementation  
  def eval(%AST.Symbol{name: name}, context) do
    {:ok, String.to_atom(name), context}
  end

  # Assert statements - evaluate condition and fail if false
  def eval(%AST.AssertStatement{condition: condition}, context) do
    case eval(condition, context) do
      {:ok, result, new_context} ->
        if is_truthy(result) do
          {:ok, result, new_context}
        else
          {:error, "assertion failed: #{inspect(condition)}"}
        end
      error -> error
    end
  end

  # Fallback for unhandled AST nodes
  def eval(ast, _context) do
    {:error, "evaluation not implemented for #{inspect(ast.__struct__)}"}
  end

  # Helper function to apply binary operations
  defp apply_binary_op(:plus, left, right) when is_number(left) and is_number(right) do
    {:ok, left + right}
  end

  defp apply_binary_op(:plus, left, right) when is_binary(left) and is_binary(right) do
    {:ok, left <> right}
  end

  defp apply_binary_op(:minus, left, right) when is_number(left) and is_number(right) do
    {:ok, left - right}
  end

  defp apply_binary_op(:multiply, left, right) when is_number(left) and is_number(right) do
    {:ok, left * right}
  end

  defp apply_binary_op(:power, left, right) when is_number(left) and is_number(right) do
    {:ok, :math.pow(left, right)}
  end

  defp apply_binary_op(:greater, left, right) when is_number(left) and is_number(right) do
    {:ok, left > right}
  end

  defp apply_binary_op(:less_equal, left, right) when is_number(left) and is_number(right) do
    {:ok, left <= right}
  end

  defp apply_binary_op(:equal, left, right) do
    {:ok, left == right}
  end

  defp apply_binary_op(:not_equal, left, right) do
    {:ok, left != right}
  end

  defp apply_binary_op(:modulo, left, right) when is_integer(left) and is_integer(right) and right != 0 do
    {:ok, rem(left, right)}
  end

  defp apply_binary_op(:modulo, _left, 0) do
    {:error, "division by zero in modulo operation"}
  end

  defp apply_binary_op(op, left, right) do
    {:error, "unsupported operation: #{op} between #{inspect(left)} and #{inspect(right)}"}
  end

  # Helper function to resolve module functions
  defp resolve_module_function("Math", function_name) do
    function_atom = String.to_atom(function_name)
    if function_exported?(Math, function_atom, 0) do
      {:ok, {Math, function_atom}}
    elsif function_exported?(Math, function_atom, 1) do
      {:ok, {Math, function_atom}}
    elsif function_exported?(Math, function_atom, 2) do
      {:ok, {Math, function_atom}}
    else
      {:error, "undefined function: Math.#{function_name}"}
    end
  end
  defp resolve_module_function("Core", function_name) do
    function_atom = String.to_atom(function_name)
    if function_exported?(Core, function_atom, 0) do
      {:ok, {Core, function_atom}}
    elsif function_exported?(Core, function_atom, 1) do
      {:ok, {Core, function_atom}}
    elsif function_exported?(Core, function_atom, 2) do
      {:ok, {Core, function_atom}}
    else
      {:error, "undefined function: Core.#{function_name}"}
    end
  end
  defp resolve_module_function(module_name, function_name) do
    {:error, "undefined module: #{module_name}"}
  end

  # Helper function to evaluate function arguments
  defp eval_args([], context), do: {:ok, [], context}
  defp eval_args([arg | rest], context) do
    case eval(arg, context) do
      {:ok, value, new_context} ->
        case eval_args(rest, new_context) do
          {:ok, values, final_context} -> {:ok, [value | values], final_context}
          error -> error
        end
      error -> error
    end
  end

  # Helper function to call lambda functions
  defp call_lambda(body, params, args, context) do
    # Check parameter count
    if length(params) != length(args) do
      {:error, "lambda parameter count mismatch: expected #{length(params)}, got #{length(args)}"}
    else
      # Create lambda parameter bindings
      lambda_context = bind_lambda_params(params, args, context)
      
      # Evaluate the lambda body with bound parameters
      case eval(body, lambda_context) do
        {:ok, result, _lambda_ctx} -> {:ok, result, context}
        error -> error
      end
    end
  end

  # Helper function to call regular functions with return handling
  defp call_function(params, body, args, context) do
    # Check parameter count
    param_count = length(params)
    arg_count = length(args)
    
    if param_count != arg_count do
      {:error, "function parameter count mismatch: expected #{param_count}, got #{arg_count}"}
    else
      # Create function parameter bindings
      function_context = bind_function_params(params, args, context)
      
      # Evaluate the function body with return handling
      case eval_function_body(body, function_context) do
        {:return, result, _func_ctx} -> {:ok, result, context}
        {:ok, result, _func_ctx} -> {:ok, result, context}
        error -> error
      end
    end
  end

  # Helper function to bind lambda parameters to argument values
  defp bind_lambda_params(params, args, context) do
    Enum.zip(params, args)
    |> Enum.reduce(context, fn {param, arg}, acc ->
      Map.put(acc, "__lambda_#{param}", arg)
    end)
  end

  # Helper function to bind function parameters to argument values
  defp bind_function_params(params, args, context) do
    Enum.zip(params, args)
    |> Enum.reduce(context, fn {%AST.Parameter{name: param_name}, arg}, acc ->
      Map.put(acc, param_name, arg)
    end)
  end

  # Helper function to evaluate function body with early return handling
  defp eval_function_body([], context), do: {:ok, nil, context}
  defp eval_function_body([stmt], context) do
    # Last statement in function body
    case eval(stmt, context) do
      {:return, value, new_context} -> {:return, value, new_context}
      {:ok, value, new_context} -> {:ok, value, new_context}
      error -> error
    end
  end
  defp eval_function_body([stmt | rest], context) do
    # Not the last statement - check for early return
    case eval(stmt, context) do
      {:return, value, new_context} -> {:return, value, new_context}
      {:ok, _value, new_context} -> eval_function_body(rest, new_context)
      error -> error
    end
  end

  # Helper function to evaluate f-string parts
  defp eval_f_string_parts([], context, acc) do
    {:ok, Enum.reverse(acc), context}
  end

  defp eval_f_string_parts([part | rest], context, acc) when is_binary(part) do
    # String literal part - use as-is
    eval_f_string_parts(rest, context, [part | acc])
  end

  defp eval_f_string_parts([part | rest], context, acc) do
    # Expression part - evaluate it
    case eval(part, context) do
      {:ok, value, new_context} ->
        string_value = to_string(value)
        eval_f_string_parts(rest, new_context, [string_value | acc])
      error -> error
    end
  end

  # Helper function to evaluate a list of expressions
  defp eval_list([], context), do: {:ok, [], context}
  defp eval_list([expr | rest], context) do
    case eval(expr, context) do
      {:ok, value, new_context} ->
        case eval_list(rest, new_context) do
          {:ok, values, final_context} -> {:ok, [value | values], final_context}
          error -> error
        end
      error -> error
    end
  end

  # Helper function to evaluate map key-value pairs
  defp eval_map_pairs([], context, acc) do
    {:ok, Enum.reverse(acc), context}
  end
  defp eval_map_pairs([{key_ast, value_ast} | rest], context, acc) do
    with {:ok, key, context1} <- eval(key_ast, context),
         {:ok, value, context2} <- eval(value_ast, context1) do
      eval_map_pairs(rest, context2, [{key, value} | acc])
    end
  end

  # Helper function to convert values to strings for f-string interpolation
  defp to_string(value) when is_binary(value), do: value
  defp to_string(value) when is_number(value), do: Kernel.to_string(value)
  defp to_string(value) when is_boolean(value), do: Kernel.to_string(value)
  defp to_string(value), do: inspect(value)

  # Helper function to determine truthiness (Rata follows common language conventions)
  defp is_truthy(nil), do: false
  defp is_truthy(false), do: false
  defp is_truthy(0), do: false
  defp is_truthy(0.0), do: false
  defp is_truthy(""), do: false
  defp is_truthy(_), do: true
end