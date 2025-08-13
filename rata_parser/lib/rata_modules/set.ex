defmodule RataModules.Set do
  @moduledoc """
  Set module for Rata programming language.
  Provides immutable set operations with wrapped returns.
  
  All functions return {:ok, result} on success or {:error, message} on failure.
  Sets are internally represented using Elixir's MapSet for efficiency.
  """

  @doc """
  Creates a new set from a vector of elements.
  
  Examples:
    Set.new([1, 2, 3, 2} -> {:ok, MapSet.new([1, 2, 3])}}
    Set.new([])          -> {:ok, MapSet.new([])}
  """
  def new(elements) when is_list(elements) do
    set = MapSet.new(elements)
    {:ok, set}
  end

  def new(_) do
    {:error, "Set.new/1 requires a vector (list) of elements"}
  end

  @doc """
  Adds an element to a set, returning a new set.
  
  Examples:
    Set.add(MapSet.new([1, 2]), 3) -> {:ok, MapSet.new([1, 2, 3])}
    Set.add(MapSet.new([1, 2]), 1) -> {:ok, MapSet.new([1, 2])}  # No duplicates
  """
  def add(%MapSet{} = set, element) do
    new_set = MapSet.put(set, element)
    {:ok, new_set}
  end

  def add(_, _) do
    {:error, "Set.add/2 requires a set as first argument"}
  end

  @doc """
  Removes an element from a set, returning a new set.
  
  Examples:
    Set.delete(MapSet.new([1, 2, 3]), 2) -> {:ok, MapSet.new([1, 3])}
    Set.delete(MapSet.new([1, 3]), 2)    -> {:ok, MapSet.new([1, 3])}  # Element not present
  """
  def delete(%MapSet{} = set, element) do
    new_set = MapSet.delete(set, element)
    {:ok, new_set}
  end

  def delete(_, _) do
    {:error, "Set.delete/2 requires a set as first argument"}
  end

  @doc """
  Checks if an element is a member of the set.
  
  Examples:
    Set.member?(MapSet.new([1, 2, 3])}, 2) -> {:ok, true}
    Set.member?(MapSet.new([1, 3]), 2)    -> {:ok, false}
  """
  def member?(%MapSet{} = set, element) do
    result = MapSet.member?(set, element)
    {:ok, result}
  end

  def member?(_, _) do
    {:error, "Set.member?/2 requires a set as first argument"}
  end

  @doc """
  Returns the number of elements in the set.
  
  Examples:
    Set.size(MapSet.new([1, 2, 3])}) -> {:ok, 3}
    Set.size(MapSet.new([]))        -> {:ok, 0}
  """
  def size(%MapSet{} = set) do
    count = MapSet.size(set)
    {:ok, count}
  end

  def size(_) do
    {:error, "Set.size/1 requires a set as argument"}
  end

  @doc """
  Returns the union of two sets.
  
  Examples:
    Set.union(MapSet.new([1, 2]), MapSet.new([2, 3])) -> {:ok, MapSet.new([1, 2, 3])}
  """
  def union(%MapSet{} = set1, %MapSet{} = set2) do
    result = MapSet.union(set1, set2)
    {:ok, result}
  end

  def union(_, _) do
    {:error, "Set.union/2 requires two sets as arguments"}
  end

  @doc """
  Returns the intersection of two sets.
  
  Examples:
    Set.intersection(MapSet.new([1, 2, 3]), MapSet.new([2, 3, 4])) -> {:ok, MapSet.new([2, 3])}
  """
  def intersection(%MapSet{} = set1, %MapSet{} = set2) do
    result = MapSet.intersection(set1, set2)
    {:ok, result}
  end

  def intersection(_, _) do
    {:error, "Set.intersection/2 requires two sets as arguments"}
  end

  @doc """
  Returns the difference of two sets (elements in first set but not in second).
  
  Examples:
    Set.difference(MapSet.new([1, 2, 3]), MapSet.new([2, 4])) -> {:ok, MapSet.new([1, 3])}
  """
  def difference(%MapSet{} = set1, %MapSet{} = set2) do
    result = MapSet.difference(set1, set2)
    {:ok, result}
  end

  def difference(_, _) do
    {:error, "Set.difference/2 requires two sets as arguments"}
  end

  @doc """
  Returns the symmetric difference of two sets (elements in either set but not in both).
  
  Examples:
    Set.symmetric_difference(MapSet.new([1, 2]), MapSet.new([2, 3])) -> {:ok, MapSet.new([1, 3])}
  """
  def symmetric_difference(%MapSet{} = set1, %MapSet{} = set2) do
    diff1 = MapSet.difference(set1, set2)
    diff2 = MapSet.difference(set2, set1)
    result = MapSet.union(diff1, diff2)
    {:ok, result}
  end

  def symmetric_difference(_, _) do
    {:error, "Set.symmetric_difference/2 requires two sets as arguments"}
  end

  @doc """
  Checks if the first set is a subset of the second set.
  
  Examples:
    Set.subset?(MapSet.new([1, 2]), MapSet.new([1, 2, 3])}) -> {:ok, true}
    Set.subset?(MapSet.new([1, 4]), MapSet.new([1, 2, 3])}) -> {:ok, false}
  """
  def subset?(%MapSet{} = set1, %MapSet{} = set2) do
    result = MapSet.subset?(set1, set2)
    {:ok, result}
  end

  def subset?(_, _) do
    {:error, "Set.subset?/2 requires two sets as arguments"}
  end

  @doc """
  Checks if two sets have no elements in common.
  
  Examples:
    Set.disjoint?(MapSet.new([1, 2]), MapSet.new([3, 4])) -> {:ok, true}
    Set.disjoint?(MapSet.new([1, 2]), MapSet.new([2, 3])) -> {:ok, false}
  """
  def disjoint?(%MapSet{} = set1, %MapSet{} = set2) do
    result = MapSet.disjoint?(set1, set2)
    {:ok, result}
  end

  def disjoint?(_, _) do
    {:error, "Set.disjoint?/2 requires two sets as arguments"}
  end

  @doc """
  Checks if two sets are equal.
  
  Examples:
    Set.equal?(MapSet.new([1, 2]), MapSet.new([2, 1])) -> {:ok, true}
    Set.equal?(MapSet.new([1, 2]), MapSet.new([1, 3])) -> {:ok, false}
  """
  def equal?(%MapSet{} = set1, %MapSet{} = set2) do
    result = MapSet.equal?(set1, set2)
    {:ok, result}
  end

  def equal?(_, _) do
    {:error, "Set.equal?/2 requires two sets as arguments"}
  end

  @doc """
  Checks if the set is empty.
  
  Examples:
    Set.empty?(MapSet.new([]))     -> {:ok, true}
    Set.empty?(MapSet.new([1, 2])) -> {:ok, false}
  """
  def empty?(%MapSet{} = set) do
    result = MapSet.size(set) == 0
    {:ok, result}
  end

  def empty?(_) do
    {:error, "Set.empty?/1 requires a set as argument"}
  end

  @doc """
  Converts a set to a vector (list).
  
  Examples:
    Set.to_vector(MapSet.new([1, 2, 3])) -> {:ok, [1, 2, 3]}  # Order may vary
  """
  def to_vector(%MapSet{} = set) do
    result = MapSet.to_list(set)
    {:ok, result}
  end

  def to_vector(_) do
    {:error, "Set.to_vector/1 requires a set as argument"}
  end

  @doc """
  Creates a set from a vector (list).
  Alias for new/1 for consistency with other modules.
  
  Examples:
    Set.from_vector([1, 2, 3, 2]) -> {:ok, MapSet.new([1, 2, 3])}
  """
  def from_vector(elements) when is_list(elements) do
    new(elements)
  end

  def from_vector(_) do
    {:error, "Set.from_vector/1 requires a vector (list) of elements"}
  end

  @doc """
  Returns an arbitrary element from the set, or error if empty.
  
  Examples:
    Set.first(MapSet.new([1, 2, 3])) -> {:ok, 1}  # Could be any element
    Set.first(MapSet.new([]))        -> {:error, "Set is empty"}
  """
  def first(%MapSet{} = set) do
    case MapSet.to_list(set) do
      [] -> {:error, "Set is empty"}
      [first | _] -> {:ok, first}
    end
  end

  def first(_) do
    {:error, "Set.first/1 requires a set as argument"}
  end

  # Alias functions following the convention: predicate? functions get is_ aliases
  
  @doc """
  Alias for member?/2. Check if an element is a member of the set.
  """
  def is_member(set, element), do: member?(set, element)

  @doc """
  Alias for subset?/2. Check if the first set is a subset of the second set.
  """
  def is_subset(set1, set2), do: subset?(set1, set2)

  @doc """
  Alias for disjoint?/2. Check if two sets have no elements in common.
  """
  def is_disjoint(set1, set2), do: disjoint?(set1, set2)

  @doc """
  Alias for equal?/2. Check if two sets are equal.
  """
  def is_equal(set1, set2), do: equal?(set1, set2)

  @doc """
  Alias for empty?/1. Check if the set is empty.
  """
  def is_empty(set), do: empty?(set)
end