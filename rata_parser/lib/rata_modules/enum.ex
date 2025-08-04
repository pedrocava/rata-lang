defmodule RataModules.Enum do
  @moduledoc """
  Enum module for the Rata programming language.
  
  Provides the basic functional programming toolkit for iterating over sequences.
  Generics for Lists and Vectors following Rata's design principles:
  - All values are vectors (no scalars)
  - 1-indexed arrays
  - Immutable by default
  - Data-first philosophy
  
  Functions include: Map, Reduce, Keep, Discard, Every, Some, None, Find.
  """

  @doc """
  Transforms each element in the enumerable using the given function.
  Returns a new collection with the transformed elements.
  
  ## Examples
      iex> Enum.map([1, 2, 3], fn x -> x * 2 end)
      {:ok, [2, 4, 6]}
  """
  def map(enumerable, function) when is_list(enumerable) and is_function(function) do
    try do
      result = Elixir.Enum.map(enumerable, function)
      {:ok, result}
    rescue
      e -> {:error, "map failed: #{Exception.message(e)}"}
    end
  end
  def map(enumerable, _function) when not is_list(enumerable) do
    {:error, "map requires a list or vector as first argument"}
  end
  def map(_enumerable, function) when not is_function(function) do
    {:error, "map requires a function as second argument"}
  end

  @doc """
  Reduces the enumerable to a single value using the given function.
  The function should accept two arguments and return a single value.
  Uses the first element as the initial accumulator.
  
  ## Examples
      iex> Enum.reduce([1, 2, 3, 4], fn x, y -> x + y end)
      {:ok, 10}
  """
  def reduce([], _function) do
    {:error, "reduce requires a non-empty collection"}
  end
  def reduce([head | tail], function) when is_function(function) do
    try do
      result = Elixir.Enum.reduce(tail, head, function)
      {:ok, result}
    rescue
      e -> {:error, "reduce failed: #{Exception.message(e)}"}
    end
  end
  def reduce(enumerable, _function) when not is_list(enumerable) do
    {:error, "reduce requires a list or vector as first argument"}
  end
  def reduce(_enumerable, function) when not is_function(function) do
    {:error, "reduce requires a function as second argument"}
  end

  @doc """
  Keeps elements for which the predicate function returns a truthy value.
  
  ## Examples
      iex> Enum.keep([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
      {:ok, [2, 4]}
  """
  def keep(enumerable, predicate) when is_list(enumerable) and is_function(predicate) do
    try do
      result = Elixir.Enum.filter(enumerable, predicate)
      {:ok, result}
    rescue
      e -> {:error, "keep failed: #{Exception.message(e)}"}
    end
  end
  def keep(enumerable, _predicate) when not is_list(enumerable) do
    {:error, "keep requires a list or vector as first argument"}
  end
  def keep(_enumerable, predicate) when not is_function(predicate) do
    {:error, "keep requires a function as second argument"}
  end

  @doc """
  Discards elements for which the predicate function returns a truthy value.
  Opposite of keep - removes elements that match the predicate.
  
  ## Examples
      iex> Enum.discard([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
      {:ok, [1, 3]}
  """
  def discard(enumerable, predicate) when is_list(enumerable) and is_function(predicate) do
    try do
      result = Elixir.Enum.reject(enumerable, predicate)
      {:ok, result}
    rescue
      e -> {:error, "discard failed: #{Exception.message(e)}"}
    end
  end
  def discard(enumerable, _predicate) when not is_list(enumerable) do
    {:error, "discard requires a list or vector as first argument"}
  end
  def discard(_enumerable, predicate) when not is_function(predicate) do
    {:error, "discard requires a function as second argument"}
  end

  @doc """
  Returns true if all elements in the enumerable satisfy the predicate function.
  Returns false if any element fails the predicate or if the collection is empty.
  
  ## Examples
      iex> Enum.every([2, 4, 6], fn x -> rem(x, 2) == 0 end)
      {:ok, true}
      
      iex> Enum.every([1, 2, 3], fn x -> rem(x, 2) == 0 end)
      {:ok, false}
  """
  def every([], _predicate) do
    {:ok, true}
  end
  def every(enumerable, predicate) when is_list(enumerable) and is_function(predicate) do
    try do
      result = Elixir.Enum.all?(enumerable, predicate)
      {:ok, result}
    rescue
      e -> {:error, "every failed: #{Exception.message(e)}"}
    end
  end
  def every(enumerable, _predicate) when not is_list(enumerable) do
    {:error, "every requires a list or vector as first argument"}
  end
  def every(_enumerable, predicate) when not is_function(predicate) do
    {:error, "every requires a function as second argument"}
  end

  @doc """
  Returns true if any element in the enumerable satisfies the predicate function.
  Returns false if no elements satisfy the predicate or if the collection is empty.
  
  ## Examples
      iex> Enum.some([1, 2, 3], fn x -> rem(x, 2) == 0 end)
      {:ok, true}
      
      iex> Enum.some([1, 3, 5], fn x -> rem(x, 2) == 0 end) 
      {:ok, false}
  """
  def some([], _predicate) do
    {:ok, false}
  end
  def some(enumerable, predicate) when is_list(enumerable) and is_function(predicate) do
    try do
      result = Elixir.Enum.any?(enumerable, predicate)
      {:ok, result}
    rescue
      e -> {:error, "some failed: #{Exception.message(e)}"}
    end
  end
  def some(enumerable, _predicate) when not is_list(enumerable) do
    {:error, "some requires a list or vector as first argument"}
  end
  def some(_enumerable, predicate) when not is_function(predicate) do
    {:error, "some requires a function as second argument"}
  end

  @doc """
  Returns true if no elements in the enumerable satisfy the predicate function.
  Returns true if all elements fail the predicate or if the collection is empty.
  
  ## Examples
      iex> Enum.none([1, 3, 5], fn x -> rem(x, 2) == 0 end)
      {:ok, true}
      
      iex> Enum.none([1, 2, 3], fn x -> rem(x, 2) == 0 end)
      {:ok, false}
  """
  def none([], _predicate) do
    {:ok, true}
  end
  def none(enumerable, predicate) when is_list(enumerable) and is_function(predicate) do
    try do
      result = not Elixir.Enum.any?(enumerable, predicate)
      {:ok, result}
    rescue
      e -> {:error, "none failed: #{Exception.message(e)}"}
    end
  end
  def none(enumerable, _predicate) when not is_list(enumerable) do
    {:error, "none requires a list or vector as first argument"}
  end
  def none(_enumerable, predicate) when not is_function(predicate) do
    {:error, "none requires a function as second argument"}
  end

  @doc """
  Finds the first element in the enumerable for which the predicate function returns a truthy value.
  Returns nil if no element satisfies the predicate.
  
  ## Examples
      iex> Enum.find([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
      {:ok, 2}
      
      iex> Enum.find([1, 3, 5], fn x -> rem(x, 2) == 0 end)
      {:ok, nil}
  """
  def find(enumerable, predicate) when is_list(enumerable) and is_function(predicate) do
    try do
      result = Elixir.Enum.find(enumerable, predicate)
      {:ok, result}
    rescue
      e -> {:error, "find failed: #{Exception.message(e)}"}
    end
  end
  def find(enumerable, _predicate) when not is_list(enumerable) do
    {:error, "find requires a list or vector as first argument"}
  end
  def find(_enumerable, predicate) when not is_function(predicate) do
    {:error, "find requires a function as second argument"}
  end
end