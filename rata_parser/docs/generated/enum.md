# Enum Module

Enum module for the Rata programming language.

Provides the basic functional programming toolkit for iterating over sequences.
Generics for Lists and Vectors following Rata's design principles:
- All values are vectors (no scalars)
- 1-indexed arrays
- Immutable by default
- Data-first philosophy

Functions include: Map, Reduce, Keep, Discard, Every, Some, None, Find.


## Import

```rata
library Enum
```

## Functions

### `every(arg, _predicate)`

Returns true if all elements in the enumerable satisfy the predicate function.
Returns false if any element fails the predicate or if the collection is empty.

## Examples
    iex> Enum.every([2, 4, 6], fn x -> rem(x, 2) == 0 end)
    {:ok, true}
    
    iex> Enum.every([1, 2, 3], fn x -> rem(x, 2) == 0 end)
    {:ok, false}



### `none(arg, _predicate)`

Returns true if no elements in the enumerable satisfy the predicate function.
Returns true if all elements fail the predicate or if the collection is empty.

## Examples
    iex> Enum.none([1, 3, 5], fn x -> rem(x, 2) == 0 end)
    {:ok, true}
    
    iex> Enum.none([1, 2, 3], fn x -> rem(x, 2) == 0 end)
    {:ok, false}



### `reduce(arg, _function)`

Reduces the enumerable to a single value using the given function.
The function should accept two arguments and return a single value.
Uses the first element as the initial accumulator.

## Examples
    iex> Enum.reduce([1, 2, 3, 4], fn x, y -> x + y end)
    {:ok, 10}



### `some(arg, _predicate)`

Returns true if any element in the enumerable satisfies the predicate function.
Returns false if no elements satisfy the predicate or if the collection is empty.

## Examples
    iex> Enum.some([1, 2, 3], fn x -> rem(x, 2) == 0 end)
    {:ok, true}
    
    iex> Enum.some([1, 3, 5], fn x -> rem(x, 2) == 0 end) 
    {:ok, false}



### `when(map, and)`

Transforms each element in the enumerable using the given function.
Returns a new collection with the transformed elements.

## Examples
    iex> Enum.map([1, 2, 3], fn x -> x * 2 end)
    {:ok, [2, 4, 6]}



### `when(map, not)`

_No documentation available._


### `when(map, not)`

_No documentation available._


### `when(reduce, is_function)`

_No documentation available._


### `when(reduce, not)`

_No documentation available._


### `when(reduce, not)`

_No documentation available._


### `when(keep, and)`

Keeps elements for which the predicate function returns a truthy value.

## Examples
    iex> Enum.keep([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
    {:ok, [2, 4]}



### `when(keep, not)`

_No documentation available._


### `when(keep, not)`

_No documentation available._


### `when(discard, and)`

Discards elements for which the predicate function returns a truthy value.
Opposite of keep - removes elements that match the predicate.

## Examples
    iex> Enum.discard([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
    {:ok, [1, 3]}



### `when(discard, not)`

_No documentation available._


### `when(discard, not)`

_No documentation available._


### `when(every, and)`

_No documentation available._


### `when(every, not)`

_No documentation available._


### `when(every, not)`

_No documentation available._


### `when(some, and)`

_No documentation available._


### `when(some, not)`

_No documentation available._


### `when(some, not)`

_No documentation available._


### `when(none, and)`

_No documentation available._


### `when(none, not)`

_No documentation available._


### `when(none, not)`

_No documentation available._


### `when(find, and)`

Finds the first element in the enumerable for which the predicate function returns a truthy value.
Returns nil if no element satisfies the predicate.

## Examples
    iex> Enum.find([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
    {:ok, 2}
    
    iex> Enum.find([1, 3, 5], fn x -> rem(x, 2) == 0 end)
    {:ok, nil}



### `when(find, not)`

_No documentation available._


### `when(find, not)`

_No documentation available._

