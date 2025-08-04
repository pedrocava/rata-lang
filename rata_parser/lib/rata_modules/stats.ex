defmodule RataModules.Stats do
  @moduledoc """
  Statistics module for the Rata programming language.
  
  Provides statistical functions and random number generation following
  Rata's design principles:
  - All values are vectors (no scalars)
  - 1-indexed arrays
  - Immutable by default
  - Data-first philosophy
  """

  @doc """
  Generate a random float between 0.0 and 1.0 (uniform distribution).
  Similar to R's runif() function.
  """
  def runif do
    {:ok, :rand.uniform()}
  end

  @doc """
  Generate a random float between min and max (uniform distribution).
  """
  def runif(min, max) when is_number(min) and is_number(max) and min < max do
    {:ok, :rand.uniform() * (max - min) + min}
  end
  def runif(min, max) when is_number(min) and is_number(max) and min >= max do
    {:error, "Stats.runif: min must be less than max, got #{min} >= #{max}"}
  end
  def runif(min, max) do
    {:error, "Stats.runif requires numeric arguments, got #{inspect(min)} and #{inspect(max)}"}
  end

  @doc """
  Generate random numbers from normal distribution.
  Similar to R's rnorm() function.
  """
  def rnorm do
    # Box-Muller transformation for normal distribution
    {:ok, :rand.normal()}
  end

  @doc """
  Generate random numbers from normal distribution with mean and std deviation.
  """
  def rnorm(mean, std) when is_number(mean) and is_number(std) and std > 0 do
    {:ok, :rand.normal() * std + mean}
  end
  def rnorm(mean, std) when is_number(mean) and is_number(std) and std <= 0 do
    {:error, "Stats.rnorm: standard deviation must be positive, got #{std}"}
  end
  def rnorm(mean, std) do
    {:error, "Stats.rnorm requires numeric arguments, got #{inspect(mean)} and #{inspect(std)}"}
  end

  @doc """
  Generate random integers from discrete uniform distribution.
  Similar to R's rdunif() function with default parameters: n=1, a=0, b=1.
  """
  def rdunif do
    rdunif(1, 0, 1)
  end

  def rdunif(n) when is_integer(n) and n > 0 do
    rdunif(n, 0, 1)
  end

  def rdunif(n, a) when is_integer(n) and n > 0 and is_integer(a) do
    rdunif(n, a, 1)
  end

  def rdunif(n, a, b) when is_integer(n) and n > 0 and is_integer(a) and is_integer(b) and a <= b do
    if n == 1 do
      {:ok, :rand.uniform(b - a + 1) + a - 1}
    else
      # Generate n random integers
      values = for _ <- 1..n, do: :rand.uniform(b - a + 1) + a - 1
      {:ok, values}
    end
  end
  def rdunif(n, a, b) when is_integer(n) and n > 0 and is_integer(a) and is_integer(b) and a > b do
    {:error, "Stats.rdunif: a must be less than or equal to b, got #{a} > #{b}"}
  end
  def rdunif(n, a, b) when is_integer(n) and n <= 0 do
    {:error, "Stats.rdunif: n must be positive, got #{n}"}
  end
  def rdunif(n, a, b) do
    {:error, "Stats.rdunif requires integer arguments, got n=#{inspect(n)}, a=#{inspect(a)}, b=#{inspect(b)}"}
  end

  @doc """
  Calculate mean of a list of numbers.
  """
  def mean(values) when is_list(values) do
    case Enum.all?(values, &is_number/1) do
      true when length(values) > 0 ->
        {:ok, Enum.sum(values) / length(values)}
      true ->
        {:error, "Stats.mean: cannot calculate mean of empty list"}
      false ->
        {:error, "Stats.mean: all values must be numeric"}
    end
  end
  def mean(value) do
    {:error, "Stats.mean requires a list, got #{inspect(value)}"}
  end

  @doc """
  Calculate standard deviation of a list of numbers.
  """
  def sd(values) when is_list(values) do
    case mean(values) do
      {:ok, mean_val} ->
        case length(values) do
          n when n > 1 ->
            variance = Enum.map(values, fn x -> :math.pow(x - mean_val, 2) end)
                      |> Enum.sum()
                      |> Kernel./(n - 1)
            {:ok, :math.sqrt(variance)}
          _ ->
            {:error, "Stats.sd: need at least 2 values to calculate standard deviation"}
        end
      error -> error
    end
  end
  def sd(value) do
    {:error, "Stats.sd requires a list, got #{inspect(value)}"}
  end

  @doc """
  Calculate variance of a list of numbers.
  """
  def var(values) when is_list(values) do
    case mean(values) do
      {:ok, mean_val} ->
        case length(values) do
          n when n > 1 ->
            variance = Enum.map(values, fn x -> :math.pow(x - mean_val, 2) end)
                      |> Enum.sum()
                      |> Kernel./(n - 1)
            {:ok, variance}
          _ ->
            {:error, "Stats.var: need at least 2 values to calculate variance"}
        end
      error -> error
    end
  end
  def var(value) do
    {:error, "Stats.var requires a list, got #{inspect(value)}"}
  end

  @doc """
  Calculate median of a list of numbers.
  """
  def median(values) when is_list(values) do
    case Enum.all?(values, &is_number/1) do
      true when length(values) > 0 ->
        sorted = Enum.sort(values)
        n = length(sorted)
        case rem(n, 2) do
          1 ->
            # Odd number of elements - middle element (1-indexed)
            middle_index = div(n + 1, 2) - 1  # Convert to 0-indexed
            {:ok, Enum.at(sorted, middle_index)}
          0 ->
            # Even number of elements - average of two middle elements
            mid1 = div(n, 2) - 1  # Convert to 0-indexed
            mid2 = mid1 + 1
            {:ok, (Enum.at(sorted, mid1) + Enum.at(sorted, mid2)) / 2}
        end
      true ->
        {:error, "Stats.median: cannot calculate median of empty list"}
      false ->
        {:error, "Stats.median: all values must be numeric"}
    end
  end
  def median(value) do
    {:error, "Stats.median requires a list, got #{inspect(value)}"}
  end

  @doc """
  Calculate quantiles of a list of numbers.
  """
  def quantiles(values, probs \\ [0.25, 0.5, 0.75]) when is_list(values) and is_list(probs) do
    case Enum.all?(values, &is_number/1) and Enum.all?(probs, &(is_number(&1) and &1 >= 0 and &1 <= 1)) do
      true when length(values) > 0 ->
        sorted = Enum.sort(values)
        n = length(sorted)
        quantile_values = Enum.map(probs, fn p ->
          index = p * (n - 1)
          lower = trunc(index)
          upper = min(lower + 1, n - 1)
          weight = index - lower
          
          lower_val = Enum.at(sorted, lower)
          upper_val = Enum.at(sorted, upper)
          
          lower_val + weight * (upper_val - lower_val)
        end)
        {:ok, Enum.zip(probs, quantile_values)}
      true ->
        {:error, "Stats.quantiles: cannot calculate quantiles of empty list"}
      false ->
        {:error, "Stats.quantiles: values must be numeric and probabilities must be between 0 and 1"}
    end
  end
  def quantiles(values, probs) do
    {:error, "Stats.quantiles requires two lists, got #{inspect(values)} and #{inspect(probs)}"}
  end
end