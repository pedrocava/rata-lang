defmodule MathTest do
  use ExUnit.Case
  alias RataModules.Math

  describe "basic arithmetic functions" do
    test "add/2 works with integers" do
      assert Math.add(2, 3) == {:ok, 5}
      assert Math.add(-1, 5) == {:ok, 4}
      assert Math.add(0, 0) == {:ok, 0}
    end

    test "add/2 works with floats" do
      assert Math.add(2.5, 3.7) == {:ok, 6.2}
      assert Math.add(-1.1, 5.1) == {:ok, 4.0}
    end

    test "add/2 handles mixed integer and float" do
      assert Math.add(2, 3.5) == {:ok, 5.5}
      assert Math.add(2.5, 3) == {:ok, 5.5}
    end

    test "add/2 returns error for non-numeric arguments" do
      assert Math.add("hello", 3) == {:error, "Math.add requires numeric arguments, got \"hello\" and 3"}
      assert Math.add(2, nil) == {:error, "Math.add requires numeric arguments, got 2 and nil"}
    end

    test "subtract/2 works correctly" do
      assert Math.subtract(5, 3) == {:ok, 2}
      assert Math.subtract(2.5, 1.5) == {:ok, 1.0}
      assert Math.subtract(-1, -3) == {:ok, 2}
    end

    test "multiply/2 works correctly" do
      assert Math.multiply(4, 5) == {:ok, 20}
      assert Math.multiply(2.5, 4) == {:ok, 10.0}
      assert Math.multiply(-2, 3) == {:ok, -6}
    end

    test "divide/2 works correctly" do
      assert Math.divide(10, 2) == {:ok, 5.0}
      assert Math.divide(7, 2) == {:ok, 3.5}
      assert Math.divide(-6, 3) == {:ok, -2.0}
    end

    test "divide/2 handles division by zero" do
      assert Math.divide(5, 0) == {:error, "Math.divide: division by zero"}
      assert Math.divide(-3, 0) == {:error, "Math.divide: division by zero"}
    end

    test "power/2 works correctly" do
      assert Math.power(2, 3) == {:ok, 8.0}
      assert Math.power(4, 0.5) == {:ok, 2.0}
      assert Math.power(5, 0) == {:ok, 1.0}
    end
  end

  describe "mathematical functions" do
    test "abs/1 works correctly" do
      assert Math.abs(5) == {:ok, 5}
      assert Math.abs(-5) == {:ok, 5}
      assert Math.abs(0) == {:ok, 0}
      assert Math.abs(-3.14) == {:ok, 3.14}
    end

    test "sqrt/1 works correctly" do
      assert Math.sqrt(4) == {:ok, 2.0}
      assert Math.sqrt(9) == {:ok, 3.0}
      assert Math.sqrt(0) == {:ok, 0.0}
      assert Math.sqrt(2) |> elem(1) |> Float.round(6) == 1.414214
    end

    test "sqrt/1 handles negative numbers" do
      assert Math.sqrt(-4) == {:error, "Math.sqrt: cannot take square root of negative number -4"}
    end

    test "square/1 works correctly" do
      assert Math.square(3) == {:ok, 9}
      assert Math.square(-4) == {:ok, 16}
      assert Math.square(2.5) == {:ok, 6.25}
    end

    test "cube/1 works correctly" do
      assert Math.cube(3) == {:ok, 27}
      assert Math.cube(-2) == {:ok, -8}
      assert Math.cube(2.0) == {:ok, 8.0}
    end

    test "factorial/1 works correctly" do
      assert Math.factorial(0) == {:ok, 1}
      assert Math.factorial(1) == {:ok, 1}
      assert Math.factorial(5) == {:ok, 120}
      assert Math.factorial(4) == {:ok, 24}
    end

    test "factorial/1 handles negative numbers" do
      assert Math.factorial(-1) == {:error, "Math.factorial: cannot compute factorial of negative number -1"}
    end

    test "factorial/1 handles non-integers" do
      assert Math.factorial(3.5) == {:error, "Math.factorial requires non-negative integer, got 3.5"}
    end
  end

  describe "transcendental functions" do
    test "exp/1 works correctly" do
      {:ok, result} = Math.exp(0)
      assert Float.round(result, 6) == 1.0

      {:ok, result} = Math.exp(1)
      assert Float.round(result, 6) == 2.718282
    end

    test "log/1 works correctly" do
      {:ok, result} = Math.log(1)
      assert result == 0.0

      {:ok, e_val} = Math.e()
      {:ok, result} = Math.log(e_val)
      assert Float.round(result, 6) == 1.0
    end

    test "log/1 handles non-positive numbers" do
      assert Math.log(0) == {:error, "Math.log: cannot take logarithm of non-positive number 0"}
      assert Math.log(-1) == {:error, "Math.log: cannot take logarithm of non-positive number -1"}
    end

    test "log10/1 works correctly" do
      assert Math.log10(1) == {:ok, 0.0}
      assert Math.log10(10) == {:ok, 1.0}
      assert Math.log10(100) == {:ok, 2.0}
    end

    test "trigonometric functions work correctly" do
      {:ok, sin_0} = Math.sin(0)
      assert Float.round(sin_0, 6) == 0.0

      {:ok, cos_0} = Math.cos(0)
      assert Float.round(cos_0, 6) == 1.0

      {:ok, tan_0} = Math.tan(0)
      assert Float.round(tan_0, 6) == 0.0

      {:ok, pi_val} = Math.pi()
      {:ok, sin_pi} = Math.sin(pi_val)
      assert Float.round(sin_pi, 6) == 0.0
    end
  end

  describe "utility functions" do
    test "max/2 works correctly" do
      assert Math.max(5, 3) == {:ok, 5}
      assert Math.max(2.1, 2.2) == {:ok, 2.2}
      assert Math.max(-1, -5) == {:ok, -1}
    end

    test "min/2 works correctly" do
      assert Math.min(5, 3) == {:ok, 3}
      assert Math.min(2.1, 2.2) == {:ok, 2.1}
      assert Math.min(-1, -5) == {:ok, -5}
    end

    test "ceil/1 works correctly" do
      assert Math.ceil(3.2) == {:ok, 4.0}
      assert Math.ceil(3.0) == {:ok, 3.0}
      assert Math.ceil(-2.1) == {:ok, -2.0}
    end

    test "floor/1 works correctly" do
      assert Math.floor(3.8) == {:ok, 3.0}
      assert Math.floor(3.0) == {:ok, 3.0}
      assert Math.floor(-2.1) == {:ok, -3.0}
    end

    test "round/1 works correctly" do
      assert Math.round(3.2) == {:ok, 3.0}
      assert Math.round(3.7) == {:ok, 4.0}
      assert Math.round(3.5) == {:ok, 4.0}
      assert Math.round(-2.5) == {:ok, -2.0}
    end

    test "is_even/1 works correctly" do
      assert Math.is_even(4) == {:ok, true}
      assert Math.is_even(5) == {:ok, false}
      assert Math.is_even(0) == {:ok, true}
      assert Math.is_even(-2) == {:ok, true}
      assert Math.is_even(-3) == {:ok, false}
    end

    test "is_even/1 handles non-integers" do
      assert Math.is_even(3.5) == {:error, "Math.is_even requires integer argument, got 3.5"}
    end

    test "is_odd/1 works correctly" do
      assert Math.is_odd(4) == {:ok, false}
      assert Math.is_odd(5) == {:ok, true}
      assert Math.is_odd(0) == {:ok, false}
      assert Math.is_odd(-1) == {:ok, true}
      assert Math.is_odd(-2) == {:ok, false}
    end
  end

  describe "constants" do
    test "pi/0 returns correct value" do
      {:ok, pi_val} = Math.pi()
      assert Float.round(pi_val, 6) == 3.141593
    end

    test "e/0 returns correct value" do
      {:ok, e_val} = Math.e()
      assert Float.round(e_val, 6) == 2.718282
    end
  end
end