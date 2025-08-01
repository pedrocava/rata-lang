defmodule RataRepl.Evaluator do
  @moduledoc """
  Evaluator for Rata AST nodes in REPL context.
  
  Provides basic evaluation of expressions, assignments, and function calls
  while maintaining session state for variables.
  """

  alias RataParser.AST

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

  # Function calls (basic - just return placeholder for now)
  def eval(%AST.FunctionCall{function: _func_ast, args: _args}, context) do
    {:error, "function calls not yet implemented"}
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
end