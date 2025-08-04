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

  @doc """
  Assert function - verifies that a condition is true.
  Throws an error if the condition is false or falsy.
  """
  def assert(condition) do
    if is_truthy(condition) do
      {:ok, condition}
    else
      {:error, "assertion failed: condition was falsy"}
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
  def typeof(value) when is_boolean(value), do: {:ok, :boolean}
  def typeof(value) when is_integer(value), do: {:ok, :integer}
  def typeof(value) when is_float(value), do: {:ok, :float}
  def typeof(value) when is_binary(value), do: {:ok, :string}
  def typeof(value) when is_atom(value), do: {:ok, :symbol}
  def typeof(value) when is_list(value), do: {:ok, :vector}
  def typeof(value) when is_tuple(value), do: {:ok, :tuple}
  def typeof(value) when is_map(value) and not is_struct(value), do: {:ok, :map}
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

  # Helper function to determine truthiness (same as evaluator)
  defp is_truthy(nil), do: false
  defp is_truthy(false), do: false
  defp is_truthy(0), do: false
  defp is_truthy(0.0), do: false
  defp is_truthy(""), do: false
  defp is_truthy(_), do: true
end