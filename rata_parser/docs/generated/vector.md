# Vector Module

Vector module for Rata programming language.

Vectors are ordered collections of values of the same type in Rata, using `[1, 2, 3]` syntax.
In Rata, there are no scalars - all values are single-entry vectors.

Key features:
- 1-indexed access following Rata conventions
- Type consistency - all elements must be same type
- Immutable operations - all functions return new vectors
- Support for common types: :int, :float, :string, :atom, :bool


## Import

```rata
library Vector
```

## Functions

### `append(_, _)`

_No documentation available._


### `at(_, _)`

_No documentation available._


### `concat(_, _)`

_No documentation available._


### `empty?(arg)`

Checks if a vector is empty.

Examples:
  Vector.empty?([]) -> true
  Vector.empty?([1, 2, 3]) -> false



### `empty?(arg)`

_No documentation available._


### `empty?(_)`

_No documentation available._


### `first(arg)`

Returns the first element of a vector.

Examples:
  Vector.first([1, 2, 3]) -> 1
  Vector.first([]) -> {:error, "Vector is empty"}



### `first(arg)`

_No documentation available._


### `first(arg)`

_No documentation available._


### `first(arg)`

_No documentation available._


### `first(_)`

_No documentation available._


### `from_list(_, _)`

_No documentation available._


### `is_empty(vector)`

Alias for empty?/1. Check if a vector is empty.



### `is_member(vector, element)`

Alias for member?/2. Check if an element is a member of the vector.



### `last(arg)`

Returns the last element of a vector.

Examples:
  Vector.last([1, 2, 3]) -> 3
  Vector.last([]) -> {:error, "Vector is empty"}



### `last(arg)`

_No documentation available._


### `last(_)`

_No documentation available._


### `length(_)`

_No documentation available._


### `member?(_, _)`

_No documentation available._


### `new()`

Creates a new empty vector.

Examples:
  Vector.new() -> []



### `new(type)`

_No documentation available._


### `reverse(_)`

_No documentation available._


### `slice(_, _, _)`

_No documentation available._


### `to_list(_)`

_No documentation available._


### `type(arg)`

Returns the type of elements in the vector.

Examples:
  Vector.type([1, 2, 3]) -> :int
  Vector.type(["a", "b"]) -> :string
  Vector.type([]) -> :unknown



### `type(arg)`

_No documentation available._


### `type(_)`

_No documentation available._


### `when(new, in)`

Creates a new empty vector with specified type.

Examples:
  Vector.new(:int) -> []
  Vector.new(:string) -> []



### `when(length, is_list)`

Returns the length of a vector.

Examples:
  Vector.length([1, 2, 3]) -> 3
  Vector.length([]) -> 0



### `when(length, is_list)`

_No documentation available._


### `when(at, and)`

Accesses element at given 1-indexed position.

Examples:
  Vector.at([1, 2, 3], 1) -> 1
  Vector.at([1, 2, 3], 3) -> 3
  Vector.at([1, 2, 3], 4) -> {:error, "Index 4 out of bounds for vector of length 3"}



### `when(at, and)`

_No documentation available._


### `when(at, and)`

_No documentation available._


### `when(at, is_list)`

_No documentation available._


### `when(last, is_list)`

_No documentation available._


### `when(last, is_list)`

_No documentation available._


### `when(type, is_integer)`

_No documentation available._


### `when(type, is_float)`

_No documentation available._


### `when(type, is_binary)`

_No documentation available._


### `when(type, is_atom)`

_No documentation available._


### `when(type, is_boolean)`

_No documentation available._


### `when(append, is_list)`

Appends an element to the end of a vector, returning a new vector.

Examples:
  Vector.append([1, 2], 3) -> [1, 2, 3]
  Vector.append([], 1) -> [1]



### `when(append, is_list)`

_No documentation available._


### `when(concat, and)`

Concatenates two vectors, returning a new vector.

Examples:
  Vector.concat([1, 2], [3, 4]) -> [1, 2, 3, 4]
  Vector.concat([], [1, 2]) -> [1, 2]



### `when(concat, and)`

_No documentation available._


### `when(concat, and)`

_No documentation available._


### `when(concat, and)`

_No documentation available._


### `when(reverse, is_list)`

Reverses the order of elements in a vector.

Examples:
  Vector.reverse([1, 2, 3]) -> [3, 2, 1]
  Vector.reverse([]) -> []



### `when(reverse, is_list)`

_No documentation available._


### `when(slice, and)`

Extracts a slice of the vector starting at 1-indexed position for given length.

Examples:
  Vector.slice([1, 2, 3, 4, 5], 2, 3) -> [2, 3, 4]
  Vector.slice([1, 2, 3], 1, 2) -> [1, 2]



### `when(slice, and)`

_No documentation available._


### `when(slice, and)`

_No documentation available._


### `when(slice, and)`

_No documentation available._


### `when(slice, is_list)`

_No documentation available._


### `when(empty?, is_list)`

_No documentation available._


### `when(empty?, is_list)`

_No documentation available._


### `when(member?, is_list)`

Checks if an element is a member of the vector.

Examples:
  Vector.member?([1, 2, 3], 2) -> true
  Vector.member?([1, 2, 3], 4) -> false



### `when(member?, is_list)`

_No documentation available._


### `when(to_list, is_list)`

Converts a vector to an Elixir list.

Examples:
  Vector.to_list([1, 2, 3]) -> [1, 2, 3]



### `when(to_list, is_list)`

_No documentation available._


### `when(from_list, and)`

Creates a vector from an Elixir list with specified type.

Examples:
  Vector.from_list([1, 2, 3], :int) -> {[1, 2, 3], :int}
  Vector.from_list(["a", "b"], :string) -> {["a", "b"], :string}



### `when(from_list, is_list)`

_No documentation available._

