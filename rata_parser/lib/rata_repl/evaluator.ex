defmodule RataRepl.Evaluator do
  @moduledoc """
  Evaluator for Rata AST nodes in REPL context.
  
  Provides basic evaluation of expressions, assignments, and function calls
  while maintaining session state for variables.
  """

  alias RataParser.AST
  alias RataModules.Math

  @doc """
  Evaluate an AST node in the given context.
  
  Returns {:ok, value, new_context} on success or {:error, reason} on failure.
  """
  def eval(ast, context \\ %{})

  # Literals - return their value directly
  def eval(%AST.Literal{value: value}, context) do
    {:ok, value, context}
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
        _ ->
          {:error, "unsupported function type: #{inspect(func)}"}
      end
    end
  end

  # Functions (basic - just return placeholder for now)
  def eval(%AST.Function{params: _params, body: _body}, context) do
    {:error, "function definitions not yet implemented"}
  end

  # Return statements - evaluate the value
  def eval(%AST.Return{value: value_ast}, context) do
    eval(value_ast, context)
  end

  # If expressions (basic - just return placeholder for now)
  def eval(%AST.If{condition: _cond, then_branch: _then, else_branch: _else}, context) do
    {:error, "if expressions not yet implemented"}
  end

  # Fallback for unhandled AST nodes
  def eval(ast, _context) do
    {:error, "evaluation not implemented for #{inspect(ast.__struct__)}"}
  end

  # Helper function to apply binary operations
  defp apply_binary_op(:plus, left, right) when is_number(left) and is_number(right) do
    {:ok, left + right}
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
end