defmodule RataModules.Math do
  @moduledoc """
  Math module for the Rata programming language.
  
  Provides basic arithmetic operators and mathematical functions following
  Rata's design principles:
  - All values are vectors (no scalars)
  - 1-indexed arrays
  - Immutable by default
  - Data-first philosophy
  """

  @doc """
  Addition function - adds two numbers.
  In Rata, this wraps the + binary operator for module-style calls.
  """
  def add(a, b) when is_number(a) and is_number(b) do
    {:ok, a + b}
  end
  def add(a, b) do
    {:error, "Math.add requires numeric arguments, got #{inspect(a)} and #{inspect(b)}"}
  end

  @doc """
  Subtraction function - subtracts second number from first.
  """
  def subtract(a, b) when is_number(a) and is_number(b) do
    {:ok, a - b}
  end
  def subtract(a, b) do
    {:error, "Math.subtract requires numeric arguments, got #{inspect(a)} and #{inspect(b)}"}
  end

  @doc """
  Multiplication function - multiplies two numbers.
  """
  def multiply(a, b) when is_number(a) and is_number(b) do
    {:ok, a * b}
  end
  def multiply(a, b) do
    {:error, "Math.multiply requires numeric arguments, got #{inspect(a)} and #{inspect(b)}"}
  end

  @doc """
  Division function - divides first number by second.
  """
  def divide(a, b) when is_number(a) and is_number(b) and b != 0 do
    {:ok, a / b}
  end
  def divide(a, 0) when is_number(a) do
    {:error, "Math.divide: division by zero"}
  end
  def divide(a, b) do
    {:error, "Math.divide requires numeric arguments, got #{inspect(a)} and #{inspect(b)}"}
  end

  @doc """
  Power function - raises first number to the power of second.
  """
  def power(a, b) when is_number(a) and is_number(b) do
    {:ok, :math.pow(a, b)}
  end
  def power(a, b) do
    {:error, "Math.power requires numeric arguments, got #{inspect(a)} and #{inspect(b)}"}
  end

  @doc """
  Absolute value function.
  """
  def abs(a) when is_number(a) do
    {:ok, Kernel.abs(a)}
  end
  def abs(a) do
    {:error, "Math.abs requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Square root function.
  """
  def sqrt(a) when is_number(a) and a >= 0 do
    {:ok, :math.sqrt(a)}
  end
  def sqrt(a) when is_number(a) and a < 0 do
    {:error, "Math.sqrt: cannot take square root of negative number #{a}"}
  end
  def sqrt(a) do
    {:error, "Math.sqrt requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Square function - returns x^2.
  """
  def square(a) when is_number(a) do
    {:ok, a * a}
  end
  def square(a) do
    {:error, "Math.square requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Cube function - returns x^3.
  """
  def cube(a) when is_number(a) do
    {:ok, a * a * a}
  end
  def cube(a) do
    {:error, "Math.cube requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Factorial function - computes n!
  """
  def factorial(n) when is_integer(n) and n >= 0 do
    {:ok, do_factorial(n)}
  end
  def factorial(n) when is_number(n) and n < 0 do
    {:error, "Math.factorial: cannot compute factorial of negative number #{n}"}
  end
  def factorial(n) when is_number(n) do
    {:error, "Math.factorial requires non-negative integer, got #{n}"}
  end
  def factorial(n) do
    {:error, "Math.factorial requires numeric argument, got #{inspect(n)}"}
  end

  defp do_factorial(0), do: 1
  defp do_factorial(n), do: n * do_factorial(n - 1)

  @doc """
  Natural exponential function - e^x.
  """
  def exp(a) when is_number(a) do
    {:ok, :math.exp(a)}
  end
  def exp(a) do
    {:error, "Math.exp requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Natural logarithm function - ln(x).
  """
  def log(a) when is_number(a) and a > 0 do
    {:ok, :math.log(a)}
  end
  def log(a) when is_number(a) and a <= 0 do
    {:error, "Math.log: cannot take logarithm of non-positive number #{a}"}
  end
  def log(a) do
    {:error, "Math.log requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Logarithm base 10 function - log10(x).
  """
  def log10(a) when is_number(a) and a > 0 do
    {:ok, :math.log10(a)}
  end
  def log10(a) when is_number(a) and a <= 0 do
    {:error, "Math.log10: cannot take logarithm of non-positive number #{a}"}
  end
  def log10(a) do
    {:error, "Math.log10 requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Sine function.
  """
  def sin(a) when is_number(a) do
    {:ok, :math.sin(a)}
  end
  def sin(a) do
    {:error, "Math.sin requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Cosine function.
  """
  def cos(a) when is_number(a) do
    {:ok, :math.cos(a)}
  end
  def cos(a) do
    {:error, "Math.cos requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Tangent function.
  """
  def tan(a) when is_number(a) do
    {:ok, :math.tan(a)}
  end
  def tan(a) do
    {:error, "Math.tan requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Pi constant.
  """
  def pi do
    {:ok, :math.pi()}
  end

  @doc """
  Euler's number constant.
  """
  def e do
    {:ok, :math.exp(1)}
  end

  @doc """
  Maximum of two numbers.
  """
  def max(a, b) when is_number(a) and is_number(b) do
    {:ok, Kernel.max(a, b)}
  end
  def max(a, b) do
    {:error, "Math.max requires numeric arguments, got #{inspect(a)} and #{inspect(b)}"}
  end

  @doc """
  Minimum of two numbers.
  """
  def min(a, b) when is_number(a) and is_number(b) do
    {:ok, Kernel.min(a, b)}
  end
  def min(a, b) do
    {:error, "Math.min requires numeric arguments, got #{inspect(a)} and #{inspect(b)}"}
  end

  @doc """
  Ceiling function - smallest integer greater than or equal to x.
  """
  def ceil(a) when is_number(a) do
    {:ok, Float.ceil(a)}
  end
  def ceil(a) do
    {:error, "Math.ceil requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Floor function - largest integer less than or equal to x.
  """
  def floor(a) when is_number(a) do
    {:ok, Float.floor(a)}
  end
  def floor(a) do
    {:error, "Math.floor requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Round function - rounds to nearest integer.
  """
  def round(a) when is_number(a) do
    {:ok, Float.round(a)}
  end
  def round(a) do
    {:error, "Math.round requires numeric argument, got #{inspect(a)}"}
  end

  @doc """
  Check if a number is even.
  """
  def is_even(n) when is_integer(n) do
    {:ok, rem(n, 2) == 0}
  end
  def is_even(n) when is_number(n) do
    {:error, "Math.is_even requires integer argument, got #{n}"}
  end
  def is_even(n) do
    {:error, "Math.is_even requires integer argument, got #{inspect(n)}"}
  end

  @doc """
  Check if a number is odd.
  """
  def is_odd(n) when is_integer(n) do
    {:ok, rem(n, 2) != 0}
  end
  def is_odd(n) when is_number(n) do
    {:error, "Math.is_odd requires integer argument, got #{n}"}
  end
  def is_odd(n) do
    {:error, "Math.is_odd requires integer argument, got #{inspect(n)}"}
  end
end