defmodule RataModules.Vector do
  @moduledoc """
  Vector module for Rata programming language.
  
  Vectors are ordered collections of values of the same type in Rata, using `[1, 2, 3]` syntax.
  In Rata, there are no scalars - all values are single-entry vectors.
  
  Key features:
  - 1-indexed access following Rata conventions
  - Type consistency - all elements must be same type
  - Immutable operations - all functions return new vectors
  - Support for common types: :int, :float, :string, :atom, :bool
  """

  @doc """
  Creates a new empty vector.
  
  Examples:
    Vector.new() -> []
  """
  def new() do
    []
  end

  @doc """
  Creates a new empty vector with specified type.
  
  Examples:
    Vector.new(:int) -> []
    Vector.new(:string) -> []
  """
  def new(type) when type in [:int, :float, :string, :atom, :bool] do
    {[], type}
  end

  def new(type) do
    {:error, "Vector.new/1 requires valid type (:int, :float, :string, :atom, :bool), got #{inspect(type)}"}
  end

  @doc """
  Returns the length of a vector.
  
  Examples:
    Vector.length([1, 2, 3]) -> 3
    Vector.length([]) -> 0
  """
  def length(vector) when is_list(vector) do
    Kernel.length(vector)
  end

  def length({vector, _type}) when is_list(vector) do
    Kernel.length(vector)
  end

  def length(_) do
    {:error, "Vector.length/1 requires a vector as argument"}
  end

  @doc """
  Accesses element at given 1-indexed position.
  
  Examples:
    Vector.at([1, 2, 3], 1) -> 1
    Vector.at([1, 2, 3], 3) -> 3
    Vector.at([1, 2, 3], 4) -> {:error, "Index 4 out of bounds for vector of length 3"}
  """
  def at(vector, index) when is_list(vector) and is_integer(index) and index > 0 do
    case Enum.at(vector, index - 1) do
      nil -> {:error, "Index #{index} out of bounds for vector of length #{Kernel.length(vector)}"}
      element -> element
    end
  end

  def at({vector, _type}, index) when is_list(vector) and is_integer(index) and index > 0 do
    at(vector, index)
  end

  def at(vector, index) when is_list(vector) and is_integer(index) and index <= 0 do
    {:error, "Vector.at/2 uses 1-based indexing, got #{index}"}
  end

  def at(vector, index) when is_list(vector) do
    {:error, "Vector.at/2 requires integer index, got #{inspect(index)}"}
  end

  def at(_, _) do
    {:error, "Vector.at/2 requires a vector as first argument"}
  end

  @doc """
  Returns the first element of a vector.
  
  Examples:
    Vector.first([1, 2, 3]) -> 1
    Vector.first([]) -> {:error, "Vector is empty"}
  """
  def first([]) do
    {:error, "Vector is empty"}
  end

  def first([first | _]) do
    first
  end

  def first({[], _type}) do
    {:error, "Vector is empty"}
  end

  def first({[first | _], _type}) do
    first
  end

  def first(_) do
    {:error, "Vector.first/1 requires a vector as argument"}
  end

  @doc """
  Returns the last element of a vector.
  
  Examples:
    Vector.last([1, 2, 3]) -> 3
    Vector.last([]) -> {:error, "Vector is empty"}
  """
  def last([]) do
    {:error, "Vector is empty"}
  end

  def last(vector) when is_list(vector) do
    List.last(vector)
  end

  def last({[], _type}) do
    {:error, "Vector is empty"}
  end

  def last({vector, _type}) when is_list(vector) do
    List.last(vector)
  end

  def last(_) do
    {:error, "Vector.last/1 requires a vector as argument"}
  end

  @doc """
  Returns the type of elements in the vector.
  
  Examples:
    Vector.type([1, 2, 3]) -> :int
    Vector.type(["a", "b"]) -> :string
    Vector.type([]) -> :unknown
  """
  def type([]) do
    :unknown
  end

  def type([first | _]) when is_integer(first) do
    :int
  end

  def type([first | _]) when is_float(first) do
    :float
  end

  def type([first | _]) when is_binary(first) do
    :string
  end

  def type([first | _]) when is_atom(first) do
    :atom
  end

  def type([first | _]) when is_boolean(first) do
    :bool
  end

  def type({_vector, type}) do
    type
  end

  def type(_) do
    {:error, "Vector.type/1 requires a vector as argument"}
  end

  @doc """
  Appends an element to the end of a vector, returning a new vector.
  
  Examples:
    Vector.append([1, 2], 3) -> [1, 2, 3]
    Vector.append([], 1) -> [1]
  """
  def append(vector, element) when is_list(vector) do
    if vector == [] or is_same_type?(element, hd(vector)) do
      vector ++ [element]
    else
      {:error, "Type mismatch: cannot append #{type_name(element)} to vector of #{type_name(hd(vector))}s"}
    end
  end

  def append({vector, type}, element) when is_list(vector) do
    if element_matches_type?(element, type) do
      {vector ++ [element], type}
    else
      {:error, "Type mismatch: cannot append #{type_name(element)} to vector of #{type}s"}
    end
  end

  def append(_, _) do
    {:error, "Vector.append/2 requires a vector as first argument"}
  end

  @doc """
  Concatenates two vectors, returning a new vector.
  
  Examples:
    Vector.concat([1, 2], [3, 4]) -> [1, 2, 3, 4]
    Vector.concat([], [1, 2]) -> [1, 2]
  """
  def concat(vector1, vector2) when is_list(vector1) and is_list(vector2) do
    cond do
      vector1 == [] -> vector2
      vector2 == [] -> vector1
      is_same_type?(hd(vector1), hd(vector2)) -> vector1 ++ vector2
      true -> {:error, "Type mismatch: cannot concatenate vector of #{type_name(hd(vector1))}s with vector of #{type_name(hd(vector2))}s"}
    end
  end

  def concat({vector1, type1}, {vector2, type2}) when is_list(vector1) and is_list(vector2) do
    if type1 == type2 do
      {vector1 ++ vector2, type1}
    else
      {:error, "Type mismatch: cannot concatenate vector of #{type1}s with vector of #{type2}s"}
    end
  end

  def concat({vector1, type}, vector2) when is_list(vector1) and is_list(vector2) do
    if vector2 == [] or all_match_type?(vector2, type) do
      {vector1 ++ vector2, type}
    else
      {:error, "Type mismatch: cannot concatenate typed vector with incompatible vector"}
    end
  end

  def concat(vector1, {vector2, type}) when is_list(vector1) and is_list(vector2) do
    if vector1 == [] or all_match_type?(vector1, type) do
      {vector1 ++ vector2, type}
    else
      {:error, "Type mismatch: cannot concatenate vector with incompatible typed vector"}
    end
  end

  def concat(_, _) do
    {:error, "Vector.concat/2 requires two vectors as arguments"}
  end

  @doc """
  Reverses the order of elements in a vector.
  
  Examples:
    Vector.reverse([1, 2, 3]) -> [3, 2, 1]
    Vector.reverse([]) -> []
  """
  def reverse(vector) when is_list(vector) do
    Enum.reverse(vector)
  end

  def reverse({vector, type}) when is_list(vector) do
    {Enum.reverse(vector), type}
  end

  def reverse(_) do
    {:error, "Vector.reverse/1 requires a vector as argument"}
  end

  @doc """
  Extracts a slice of the vector starting at 1-indexed position for given length.
  
  Examples:
    Vector.slice([1, 2, 3, 4, 5], 2, 3) -> [2, 3, 4]
    Vector.slice([1, 2, 3], 1, 2) -> [1, 2]
  """
  def slice(vector, start, length) when is_list(vector) and is_integer(start) and is_integer(length) and start > 0 and length >= 0 do
    vector
    |> Enum.drop(start - 1)
    |> Enum.take(length)
  end

  def slice({vector, type}, start, length) when is_list(vector) and is_integer(start) and is_integer(length) and start > 0 and length >= 0 do
    result = vector
    |> Enum.drop(start - 1)
    |> Enum.take(length)
    {result, type}
  end

  def slice(vector, start, _length) when is_list(vector) and is_integer(start) and start <= 0 do
    {:error, "Vector.slice/3 uses 1-based indexing, start position must be > 0, got #{start}"}
  end

  def slice(vector, _start, length) when is_list(vector) and is_integer(length) and length < 0 do
    {:error, "Vector.slice/3 requires non-negative length, got #{length}"}
  end

  def slice(vector, start, length) when is_list(vector) do
    {:error, "Vector.slice/3 requires integer start and length, got #{inspect(start)} and #{inspect(length)}"}
  end

  def slice(_, _, _) do
    {:error, "Vector.slice/3 requires a vector as first argument"}
  end

  @doc """
  Checks if a vector is empty.
  
  Examples:
    Vector.empty?([]) -> true
    Vector.empty?([1, 2, 3]) -> false
  """
  def empty?([]) do
    true
  end

  def empty?(vector) when is_list(vector) do
    false
  end

  def empty?({[], _type}) do
    true
  end

  def empty?({vector, _type}) when is_list(vector) do
    false
  end

  def empty?(_) do
    {:error, "Vector.empty?/1 requires a vector as argument"}
  end

  @doc """
  Checks if an element is a member of the vector.
  
  Examples:
    Vector.member?([1, 2, 3], 2) -> true
    Vector.member?([1, 2, 3], 4) -> false
  """
  def member?(vector, element) when is_list(vector) do
    Enum.member?(vector, element)
  end

  def member?({vector, _type}, element) when is_list(vector) do
    Enum.member?(vector, element)
  end

  def member?(_, _) do
    {:error, "Vector.member?/2 requires a vector as first argument"}
  end

  @doc """
  Converts a vector to an Elixir list.
  
  Examples:
    Vector.to_list([1, 2, 3]) -> [1, 2, 3]
  """
  def to_list(vector) when is_list(vector) do
    vector
  end

  def to_list({vector, _type}) when is_list(vector) do
    vector
  end

  def to_list(_) do
    {:error, "Vector.to_list/1 requires a vector as argument"}
  end

  @doc """
  Creates a vector from an Elixir list with specified type.
  
  Examples:
    Vector.from_list([1, 2, 3], :int) -> {[1, 2, 3], :int}
    Vector.from_list(["a", "b"], :string) -> {["a", "b"], :string}
  """
  def from_list(list, type) when is_list(list) and type in [:int, :float, :string, :atom, :bool] do
    if list == [] or all_match_type?(list, type) do
      {list, type}
    else
      {:error, "List elements do not match specified type #{type}"}
    end
  end

  def from_list(list, _type) when is_list(list) do
    {:error, "Vector.from_list/2 requires valid type (:int, :float, :string, :atom, :bool)"}
  end

  def from_list(_, _) do
    {:error, "Vector.from_list/2 requires a list as first argument"}
  end

  # Alias functions for predicates with is_ prefix
  
  @doc """
  Alias for empty?/1. Check if a vector is empty.
  """
  def is_empty(vector), do: empty?(vector)

  @doc """
  Alias for member?/2. Check if an element is a member of the vector.
  """
  def is_member(vector, element), do: member?(vector, element)

  # Private helper functions

  defp is_same_type?(a, b) do
    type_name(a) == type_name(b)
  end

  defp type_name(value) when is_integer(value), do: :int
  defp type_name(value) when is_float(value), do: :float
  defp type_name(value) when is_binary(value), do: :string
  defp type_name(value) when is_atom(value), do: :atom
  defp type_name(value) when is_boolean(value), do: :bool

  defp element_matches_type?(element, :int), do: is_integer(element)
  defp element_matches_type?(element, :float), do: is_float(element)
  defp element_matches_type?(element, :string), do: is_binary(element)
  defp element_matches_type?(element, :atom), do: is_atom(element)
  defp element_matches_type?(element, :bool), do: is_boolean(element)

  defp all_match_type?([], _type), do: true
  defp all_match_type?([h | t], type) do
    element_matches_type?(h, type) and all_match_type?(t, type)
  end
end