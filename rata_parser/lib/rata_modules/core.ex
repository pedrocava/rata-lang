defmodule RataModules.Core do
  @moduledoc """
  Core module for the Rata programming language.
  
  Provides basic language primitives and core functionality following
  Rata's design principles:
  - All values are vectors (no scalars)
  - 1-indexed arrays
  - Immutable by default
  - Data-first philosophy
  """

  import Kernel, except: [is_boolean: 1, is_float: 1, is_function: 1, is_integer: 1, is_list: 1, is_map: 1, is_number: 1, is_tuple: 1]

  @doc """
  Assert function - verifies that a condition is true.
  Throws an error if the condition is false or falsy.
  """
  def assert(condition) do
    if is_truthy_helper(condition) do
      {:ok, condition}
    else
      {:error, "assertion failed: condition was falsy"}
    end
  end

  @doc """
  Assert function with custom message.
  Throws an error with the provided message if condition is falsy.
  """
  def assert(condition, message) do
    if is_truthy_helper(condition) do
      {:ok, condition}
    else
      {:error, "assertion failed: #{message}"}
    end
  end

  @doc """
  Identity function - returns its argument unchanged.
  Useful for testing and as a placeholder.
  """
  def identity(value) do
    {:ok, value}
  end

  @doc """
  Type checking function - returns the type of a value as an atom.
  """
  def typeof(nil), do: {:ok, :nil}
  def typeof(value) when Kernel.is_boolean(value), do: {:ok, :boolean}
  def typeof(value) when Kernel.is_integer(value), do: {:ok, :integer}
  def typeof(value) when Kernel.is_float(value), do: {:ok, :float}
  def typeof(value) when is_binary(value), do: {:ok, :string}
  def typeof(value) when is_atom(value), do: {:ok, :symbol}
  def typeof(value) when Kernel.is_list(value), do: {:ok, :vector}
  def typeof(value) when Kernel.is_tuple(value), do: {:ok, :tuple}
  def typeof(value) when Kernel.is_map(value) and not Kernel.is_struct(value), do: {:ok, :map}
  def typeof(%MapSet{}), do: {:ok, :set}
  def typeof(%Range{}), do: {:ok, :range}
  def typeof(_), do: {:ok, :unknown}

  @doc """
  Debug print function - prints a value and returns it unchanged.
  Useful for debugging pipelines.
  """
  def debug(value) do
    IO.inspect(value, label: "DEBUG")
    {:ok, value}
  end

  @doc """
  Debug print with custom label.
  """
  def debug(value, label) when is_binary(label) do
    IO.inspect(value, label: label)
    {:ok, value}
  end
  def debug(value, label) do
    IO.inspect(value, label: inspect(label))
    {:ok, value}
  end

  @doc """
  Create a new exception with the given type.
  """
  def exception(type) when is_atom(type) do
    {:ok, %{exception: type, message: nil, stacktrace: nil}}
  end
  def exception(type) when is_binary(type) do
    {:ok, %{exception: String.to_atom(type), message: nil, stacktrace: nil}}
  end

  @doc """
  Create a new exception with type and message.
  """
  def exception(type, message) when is_atom(type) do
    {:ok, %{exception: type, message: message, stacktrace: nil}}
  end
  def exception(type, message) when is_binary(type) do
    {:ok, %{exception: String.to_atom(type), message: message, stacktrace: nil}}
  end

  @doc """
  Create a RuntimeError exception (most common type).
  """
  def runtime_error(message) do
    {:ok, %{exception: :runtime_error, message: message, stacktrace: nil}}
  end

  @doc """
  Create an ArgumentError exception.
  """
  def argument_error(message) do
    {:ok, %{exception: :argument_error, message: message, stacktrace: nil}}
  end

  @doc """
  Create a TypeError exception.
  """
  def type_error(message) do
    {:ok, %{exception: :type_error, message: message, stacktrace: nil}}
  end

  @doc """
  Create a ValueError exception.
  """
  def value_error(message) do
    {:ok, %{exception: :value_error, message: message, stacktrace: nil}}
  end

  @doc """
  Get the exception type from an exception.
  """
  def exception_type(%{exception: type}), do: {:ok, type}
  def exception_type(_), do: {:error, "not an exception"}

  @doc """
  Get the message from an exception.
  """
  def exception_message(%{message: message}), do: {:ok, message}
  def exception_message(_), do: {:error, "not an exception"}

  @doc """
  Check if a value is an exception.
  """
  def is_exception(%{exception: _}), do: {:ok, true}
  def is_exception(_), do: {:ok, false}

  # Type predicate functions
  @doc """
  Check if a value is a list.
  """
  def is_list(value) when Kernel.is_list(value), do: {:ok, true}
  def is_list(_), do: {:ok, false}

  @doc """
  Check if a value is a vector (same as list in Rata).
  """
  def is_vector(value) when Kernel.is_list(value), do: {:ok, true}
  def is_vector(_), do: {:ok, false}

  @doc """
  Check if a value is a map.
  """
  def is_map(value) when Kernel.is_map(value) and not Kernel.is_struct(value), do: {:ok, true}
  def is_map(_), do: {:ok, false}

  @doc """
  Check if a value is a table (Explorer DataFrame).
  """
  # def is_table(%Explorer.DataFrame{}), do: {:ok, true}  # Temporarily disabled
  def is_table(_), do: {:ok, false}

  @doc """
  Check if a value is a boolean.
  """
  def is_boolean(value) when Kernel.is_boolean(value), do: {:ok, true}
  def is_boolean(_), do: {:ok, false}

  @doc """
  Check if a value is an integer.
  """
  def is_integer(value) when Kernel.is_integer(value), do: {:ok, true}
  def is_integer(_), do: {:ok, false}

  @doc """
  Check if a value is a float.
  """
  def is_float(value) when Kernel.is_float(value), do: {:ok, true}
  def is_float(_), do: {:ok, false}

  @doc """
  Check if a value is a number (integer or float).
  """
  def is_number(value) when Kernel.is_number(value), do: {:ok, true}
  def is_number(_), do: {:ok, false}

  @doc """
  Check if a value is a string.
  """
  def is_string(value) when is_binary(value), do: {:ok, true}
  def is_string(_), do: {:ok, false}

  @doc """
  Check if a value is a symbol (atom).
  """
  def is_symbol(value) when is_atom(value), do: {:ok, true}
  def is_symbol(_), do: {:ok, false}

  @doc """
  Check if a value is a tuple.
  """
  def is_tuple(value) when Kernel.is_tuple(value), do: {:ok, true}
  def is_tuple(_), do: {:ok, false}

  @doc """
  Check if a value is a set.
  """
  def is_set(%MapSet{}), do: {:ok, true}
  def is_set(_), do: {:ok, false}

  @doc """
  Check if a value is a range.
  """
  def is_range(%Range{}), do: {:ok, true}
  def is_range(_), do: {:ok, false}

  @doc """
  Check if a value is nil.
  """
  def is_nil(nil), do: {:ok, true}
  def is_nil(_), do: {:ok, false}

  @doc """
  Check if a value is a function.
  """
  def is_function(value) when Kernel.is_function(value), do: {:ok, true}
  def is_function(_), do: {:ok, false}

  @doc """
  Check if a value is truthy according to Rata's truthiness rules.
  Public version of the truthiness evaluation.
  """
  def is_truthy(value), do: {:ok, is_truthy_helper(value)}

  # Helper function to determine truthiness (same as evaluator)
  defp is_truthy_helper(nil), do: false
  defp is_truthy_helper(false), do: false
  defp is_truthy_helper(0), do: false
  defp is_truthy_helper(0.0), do: false
  defp is_truthy_helper(""), do: false
  defp is_truthy_helper(_), do: true
end