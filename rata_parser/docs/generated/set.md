# Set Module

Set module for Rata programming language.
Provides immutable set operations with wrapped returns.

All functions return {:ok, result} on success or {:error, message} on failure.
Sets are internally represented using Elixir's MapSet for efficiency.


## Import

```rata
library Set
```

## Functions

### `add(=, element)`

Adds an element to a set, returning a new set.

Examples:
  Set.add(MapSet.new([1, 2]), 3) -> {:ok, MapSet.new([1, 2, 3])}
  Set.add(MapSet.new([1, 2]), 1) -> {:ok, MapSet.new([1, 2])}  # No duplicates



### `add(_, _)`

_No documentation available._


### `delete(=, element)`

Removes an element from a set, returning a new set.

Examples:
  Set.delete(MapSet.new([1, 2, 3]), 2) -> {:ok, MapSet.new([1, 3])}
  Set.delete(MapSet.new([1, 3]), 2)    -> {:ok, MapSet.new([1, 3])}  # Element not present



### `delete(_, _)`

_No documentation available._


### `difference(=, =)`

Returns the difference of two sets (elements in first set but not in second).

Examples:
  Set.difference(MapSet.new([1, 2, 3]), MapSet.new([2, 4])) -> {:ok, MapSet.new([1, 3])}



### `difference(_, _)`

_No documentation available._


### `disjoint?(=, =)`

Checks if two sets have no elements in common.

Examples:
  Set.disjoint?(MapSet.new([1, 2]), MapSet.new([3, 4])) -> {:ok, true}
  Set.disjoint?(MapSet.new([1, 2]), MapSet.new([2, 3])) -> {:ok, false}



### `disjoint?(_, _)`

_No documentation available._


### `empty?(=)`

Checks if the set is empty.

Examples:
  Set.empty?(MapSet.new([]))     -> {:ok, true}
  Set.empty?(MapSet.new([1, 2])) -> {:ok, false}



### `empty?(_)`

_No documentation available._


### `equal?(=, =)`

Checks if two sets are equal.

Examples:
  Set.equal?(MapSet.new([1, 2]), MapSet.new([2, 1])) -> {:ok, true}
  Set.equal?(MapSet.new([1, 2]), MapSet.new([1, 3])) -> {:ok, false}



### `equal?(_, _)`

_No documentation available._


### `first(=)`

Returns an arbitrary element from the set, or error if empty.

Examples:
  Set.first(MapSet.new([1, 2, 3])) -> {:ok, 1}  # Could be any element
  Set.first(MapSet.new([]))        -> {:error, "Set is empty"}



### `first(_)`

_No documentation available._


### `from_vector(_)`

_No documentation available._


### `intersection(=, =)`

Returns the intersection of two sets.

Examples:
  Set.intersection(MapSet.new([1, 2, 3]), MapSet.new([2, 3, 4])) -> {:ok, MapSet.new([2, 3])}



### `intersection(_, _)`

_No documentation available._


### `is_disjoint(set1, set2)`

Alias for disjoint?/2. Check if two sets have no elements in common.



### `is_empty(set)`

Alias for empty?/1. Check if the set is empty.



### `is_equal(set1, set2)`

Alias for equal?/2. Check if two sets are equal.



### `is_member(set, element)`

Alias for member?/2. Check if an element is a member of the set.



### `is_subset(set1, set2)`

Alias for subset?/2. Check if the first set is a subset of the second set.



### `member?(=, element)`

Checks if an element is a member of the set.

Examples:
  Set.member?(MapSet.new([1, 2, 3])}, 2) -> {:ok, true}
  Set.member?(MapSet.new([1, 3]), 2)    -> {:ok, false}



### `member?(_, _)`

_No documentation available._


### `new(_)`

_No documentation available._


### `size(=)`

Returns the number of elements in the set.

Examples:
  Set.size(MapSet.new([1, 2, 3])}) -> {:ok, 3}
  Set.size(MapSet.new([]))        -> {:ok, 0}



### `size(_)`

_No documentation available._


### `subset?(=, =)`

Checks if the first set is a subset of the second set.

Examples:
  Set.subset?(MapSet.new([1, 2]), MapSet.new([1, 2, 3])}) -> {:ok, true}
  Set.subset?(MapSet.new([1, 4]), MapSet.new([1, 2, 3])}) -> {:ok, false}



### `subset?(_, _)`

_No documentation available._


### `symmetric_difference(=, =)`

Returns the symmetric difference of two sets (elements in either set but not in both).

Examples:
  Set.symmetric_difference(MapSet.new([1, 2]), MapSet.new([2, 3])) -> {:ok, MapSet.new([1, 3])}



### `symmetric_difference(_, _)`

_No documentation available._


### `to_vector(=)`

Converts a set to a vector (list).

Examples:
  Set.to_vector(MapSet.new([1, 2, 3])) -> {:ok, [1, 2, 3]}  # Order may vary



### `to_vector(_)`

_No documentation available._


### `union(=, =)`

Returns the union of two sets.

Examples:
  Set.union(MapSet.new([1, 2]), MapSet.new([2, 3])) -> {:ok, MapSet.new([1, 2, 3])}



### `union(_, _)`

_No documentation available._


### `when(new, is_list)`

Creates a new set from a vector of elements.

Examples:
  Set.new([1, 2, 3, 2} -> {:ok, MapSet.new([1, 2, 3])}}
  Set.new([])          -> {:ok, MapSet.new([])}



### `when(from_vector, is_list)`

Creates a set from a vector (list).
Alias for new/1 for consistency with other modules.

Examples:
  Set.from_vector([1, 2, 3, 2]) -> {:ok, MapSet.new([1, 2, 3])}


