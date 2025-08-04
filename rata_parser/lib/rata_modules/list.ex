defmodule RataModules.List do
  @moduledoc """
  List module for the Rata programming language.
  
  Provides fundamental list operations following Rata's design principles:
  - All values are vectors (no scalars)
  - 1-indexed arrays (following R conventions)
  - Immutable by default
  - Data-first philosophy
  
  Functions include: first, rest, last, is_empty, length, prepend, append, 
  concat, reverse, take, drop, at.
  """

  @doc """
  Returns the first element of a list, or nil if the list is empty.
  
  ## Examples
      iex> List.first([1, 2, 3])
      {:ok, 1}
      
      iex> List.first([])
      {:ok, nil}
  """
  def first([]), do: {:ok, nil}
  def first([head | _tail]) when is_list([head | _tail]) do
    {:ok, head}
  end
  def first(value) when not is_list(value) do
    {:error, "List.first requires a list argument, got #{inspect(value)}"}
  end

  @doc """
  Returns all elements except the first (the tail of the list).
  Returns an empty list if the input list is empty or has only one element.
  
  ## Examples
      iex> List.rest([1, 2, 3])
      {:ok, [2, 3]}
      
      iex> List.rest([1])
      {:ok, []}
      
      iex> List.rest([])
      {:ok, []}
  """
  def rest([]), do: {:ok, []}
  def rest([_head | tail]) when is_list([_head | tail]) do
    {:ok, tail}
  end
  def rest(value) when not is_list(value) do
    {:error, "List.rest requires a list argument, got #{inspect(value)}"}
  end

  @doc """
  Returns the last element of a list, or nil if the list is empty.
  
  ## Examples
      iex> List.last([1, 2, 3])
      {:ok, 3}
      
      iex> List.last([])
      {:ok, nil}
  """
  def last([]), do: {:ok, nil}
  def last(list) when is_list(list) do
    {:ok, Elixir.List.last(list)}
  end
  def last(value) when not is_list(value) do
    {:error, "List.last requires a list argument, got #{inspect(value)}"}
  end

  @doc """
  Returns true if the list is empty, false otherwise.
  
  ## Examples
      iex> List.is_empty([])
      {:ok, true}
      
      iex> List.is_empty([1, 2])
      {:ok, false}
  """
  def is_empty([]), do: {:ok, true}
  def is_empty(list) when is_list(list), do: {:ok, false}
  def is_empty(value) when not is_list(value) do
    {:error, "List.is_empty requires a list argument, got #{inspect(value)}"}
  end

  @doc """
  Returns the length of a list.
  
  ## Examples
      iex> List.length([1, 2, 3])
      {:ok, 3}
      
      iex> List.length([])
      {:ok, 0}
  """
  def length(list) when is_list(list) do
    {:ok, Kernel.length(list)}
  end
  def length(value) when not is_list(value) do
    {:error, "List.length requires a list argument, got #{inspect(value)}"}
  end

  @doc """
  Prepends an element to the beginning of a list.
  
  ## Examples
      iex> List.prepend([2, 3], 1)
      {:ok, [1, 2, 3]}
      
      iex> List.prepend([], 1)
      {:ok, [1]}
  """
  def prepend(list, element) when is_list(list) do
    {:ok, [element | list]}
  end
  def prepend(value, _element) when not is_list(value) do
    {:error, "List.prepend requires a list as first argument, got #{inspect(value)}"}
  end

  @doc """
  Appends an element to the end of a list.
  
  ## Examples
      iex> List.append([1, 2], 3)
      {:ok, [1, 2, 3]}
      
      iex> List.append([], 1)
      {:ok, [1]}
  """
  def append(list, element) when is_list(list) do
    {:ok, list ++ [element]}
  end
  def append(value, _element) when not is_list(value) do
    {:error, "List.append requires a list as first argument, got #{inspect(value)}"}
  end

  @doc """
  Concatenates two lists together.
  
  ## Examples
      iex> List.concat([1, 2], [3, 4])
      {:ok, [1, 2, 3, 4]}
      
      iex> List.concat([], [1, 2])
      {:ok, [1, 2]}
  """
  def concat(list1, list2) when is_list(list1) and is_list(list2) do
    {:ok, list1 ++ list2}
  end
  def concat(list1, list2) when not is_list(list1) do
    {:error, "List.concat requires a list as first argument, got #{inspect(list1)}"}
  end
  def concat(_list1, list2) when not is_list(list2) do
    {:error, "List.concat requires a list as second argument, got #{inspect(list2)}"}
  end

  @doc """
  Reverses the order of elements in a list.
  
  ## Examples
      iex> List.reverse([1, 2, 3])
      {:ok, [3, 2, 1]}
      
      iex> List.reverse([])
      {:ok, []}
  """
  def reverse(list) when is_list(list) do
    {:ok, Elixir.Enum.reverse(list)}
  end
  def reverse(value) when not is_list(value) do
    {:error, "List.reverse requires a list argument, got #{inspect(value)}"}
  end

  @doc """
  Takes the first n elements from a list.
  Returns fewer elements if the list is shorter than n.
  
  ## Examples
      iex> List.take([1, 2, 3, 4], 2)
      {:ok, [1, 2]}
      
      iex> List.take([1, 2], 5)
      {:ok, [1, 2]}
      
      iex> List.take([], 3)
      {:ok, []}
  """
  def take(list, n) when is_list(list) and is_integer(n) and n >= 0 do
    {:ok, Elixir.Enum.take(list, n)}
  end
  def take(list, n) when is_list(list) and is_integer(n) and n < 0 do
    {:error, "List.take requires a non-negative integer, got #{n}"}
  end
  def take(list, n) when is_list(list) and not is_integer(n) do
    {:error, "List.take requires an integer as second argument, got #{inspect(n)}"}
  end
  def take(value, _n) when not is_list(value) do
    {:error, "List.take requires a list as first argument, got #{inspect(value)}"}
  end

  @doc """
  Drops the first n elements from a list.
  Returns an empty list if n is greater than or equal to the list length.
  
  ## Examples
      iex> List.drop([1, 2, 3, 4], 2)
      {:ok, [3, 4]}
      
      iex> List.drop([1, 2], 5)
      {:ok, []}
      
      iex> List.drop([], 3)
      {:ok, []}
  """
  def drop(list, n) when is_list(list) and is_integer(n) and n >= 0 do
    {:ok, Elixir.Enum.drop(list, n)}
  end
  def drop(list, n) when is_list(list) and is_integer(n) and n < 0 do
    {:error, "List.drop requires a non-negative integer, got #{n}"}
  end
  def drop(list, n) when is_list(list) and not is_integer(n) do
    {:error, "List.drop requires an integer as second argument, got #{inspect(n)}"}
  end
  def drop(value, _n) when not is_list(value) do
    {:error, "List.drop requires a list as first argument, got #{inspect(value)}"}
  end

  @doc """
  Returns the element at the given 1-based index.
  Returns nil if the index is out of bounds.
  Following Rata's 1-indexed convention (like R).
  
  ## Examples
      iex> List.at([1, 2, 3], 1)
      {:ok, 1}
      
      iex> List.at([1, 2, 3], 3)
      {:ok, 3}
      
      iex> List.at([1, 2, 3], 5)
      {:ok, nil}
      
      iex> List.at([1, 2, 3], 0)
      {:error, "List.at uses 1-based indexing, got 0"}
  """
  def at(list, index) when is_list(list) and is_integer(index) and index > 0 do
    # Convert to 0-based index for Elixir's Enum.at
    zero_based_index = index - 1
    {:ok, Elixir.Enum.at(list, zero_based_index)}
  end
  def at(list, index) when is_list(list) and is_integer(index) and index <= 0 do
    {:error, "List.at uses 1-based indexing, got #{index}"}
  end
  def at(list, index) when is_list(list) and not is_integer(index) do
    {:error, "List.at requires an integer index, got #{inspect(index)}"}
  end
  def at(value, _index) when not is_list(value) do
    {:error, "List.at requires a list as first argument, got #{inspect(value)}"}
  end
end