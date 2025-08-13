# List Module

List module for the Rata programming language.

Provides fundamental list operations following Rata's design principles:
- All values are vectors (no scalars)
- 1-indexed arrays (following R conventions)
- Immutable by default
- Data-first philosophy

Functions include: first, rest, last, is_empty, length, prepend, append, 
concat, reverse, take, drop, at.


## Import

```rata
library List
```

## Functions

### `first(arg)`

Returns the first element of a list, or nil if the list is empty.

## Examples
    iex> List.first([1, 2, 3])
    {:ok, 1}
    
    iex> List.first([])
    {:ok, nil}



### `is_empty(arg)`

Returns true if the list is empty, false otherwise.

## Examples
    iex> List.is_empty([])
    {:ok, true}
    
    iex> List.is_empty([1, 2])
    {:ok, false}



### `last(arg)`

Returns the last element of a list, or nil if the list is empty.

## Examples
    iex> List.last([1, 2, 3])
    {:ok, 3}
    
    iex> List.last([])
    {:ok, nil}



### `rest(arg)`

Returns all elements except the first (the tail of the list).
Returns an empty list if the input list is empty or has only one element.

## Examples
    iex> List.rest([1, 2, 3])
    {:ok, [2, 3]}
    
    iex> List.rest([1])
    {:ok, []}
    
    iex> List.rest([])
    {:ok, []}



### `when(first, is_list)`

_No documentation available._


### `when(first, not)`

_No documentation available._


### `when(rest, is_list)`

_No documentation available._


### `when(rest, not)`

_No documentation available._


### `when(last, is_list)`

_No documentation available._


### `when(last, not)`

_No documentation available._


### `when(is_empty, is_list)`

_No documentation available._


### `when(is_empty, not)`

_No documentation available._


### `when(length, is_list)`

Returns the length of a list.

## Examples
    iex> List.length([1, 2, 3])
    {:ok, 3}
    
    iex> List.length([])
    {:ok, 0}



### `when(length, not)`

_No documentation available._


### `when(prepend, is_list)`

Prepends an element to the beginning of a list.

## Examples
    iex> List.prepend([2, 3], 1)
    {:ok, [1, 2, 3]}
    
    iex> List.prepend([], 1)
    {:ok, [1]}



### `when(prepend, not)`

_No documentation available._


### `when(append, is_list)`

Appends an element to the end of a list.

## Examples
    iex> List.append([1, 2], 3)
    {:ok, [1, 2, 3]}
    
    iex> List.append([], 1)
    {:ok, [1]}



### `when(append, not)`

_No documentation available._


### `when(concat, and)`

Concatenates two lists together.

## Examples
    iex> List.concat([1, 2], [3, 4])
    {:ok, [1, 2, 3, 4]}
    
    iex> List.concat([], [1, 2])
    {:ok, [1, 2]}



### `when(concat, not)`

_No documentation available._


### `when(concat, not)`

_No documentation available._


### `when(reverse, is_list)`

Reverses the order of elements in a list.

## Examples
    iex> List.reverse([1, 2, 3])
    {:ok, [3, 2, 1]}
    
    iex> List.reverse([])
    {:ok, []}



### `when(reverse, not)`

_No documentation available._


### `when(take, and)`

Takes the first n elements from a list.
Returns fewer elements if the list is shorter than n.

## Examples
    iex> List.take([1, 2, 3, 4], 2)
    {:ok, [1, 2]}
    
    iex> List.take([1, 2], 5)
    {:ok, [1, 2]}
    
    iex> List.take([], 3)
    {:ok, []}



### `when(take, and)`

_No documentation available._


### `when(take, and)`

_No documentation available._


### `when(take, not)`

_No documentation available._


### `when(drop, and)`

Drops the first n elements from a list.
Returns an empty list if n is greater than or equal to the list length.

## Examples
    iex> List.drop([1, 2, 3, 4], 2)
    {:ok, [3, 4]}
    
    iex> List.drop([1, 2], 5)
    {:ok, []}
    
    iex> List.drop([], 3)
    {:ok, []}



### `when(drop, and)`

_No documentation available._


### `when(drop, and)`

_No documentation available._


### `when(drop, not)`

_No documentation available._


### `when(at, and)`

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



### `when(at, and)`

_No documentation available._


### `when(at, and)`

_No documentation available._


### `when(at, not)`

_No documentation available._

