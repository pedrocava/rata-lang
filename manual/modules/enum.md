# Enum Module

The Enum module provides functional programming utilities for working with collections (vectors, lists, maps, sets). It's the generic toolkit for iteration and transformation.

## Overview

Enum provides:
- **Generic operations**: Work with any enumerable collection
- **Functional programming**: Map, reduce, filter, and more
- **Lazy evaluation**: Some operations are optimized for performance
- **Composability**: Operations chain together naturally

## Import

```rata
library Enum as e
```

## Core Operations

### `map(collection, function)` - Transform each element
### `filter(collection, predicate)` - Keep matching elements
### `reduce(collection, function, initial)` - Reduce to single value
### `each(collection, function)` - Execute function for side effects
### `count(collection, predicate \\= nil)` - Count elements or matching elements

## Conditional Operations

### `all?(collection, predicate)` - Test if all elements match
### `any?(collection, predicate)` - Test if any element matches
### `none?(collection, predicate)` - Test if no elements match
### `find(collection, predicate)` - Find first matching element
### `member?(collection, element)` - Test if element is in collection

## Collection Operations

### `chunk_every(collection, count)` - Split into chunks of size count
### `take(collection, count)` - Take first count elements
### `drop(collection, count)` - Skip first count elements
### `zip(collection1, collection2)` - Combine elements from two collections

## Usage Examples

```rata
numbers = [1, 2, 3, 4, 5]

# Transform and filter
result = numbers
  |> Enum.map(~ .x * 2)      # [2, 4, 6, 8, 10]
  |> Enum.filter(~ .x > 5)    # [6, 8, 10]
  |> Enum.reduce(Math.add/2, 0) # 24

# Working with different collection types
user_ages = {alice: 25, bob: 30, charlie: 35}
adults = user_ages |> Enum.filter(fn {name, age} -> age >= 18 end)
```

---

*This is a skeleton for the Enum module documentation. Full implementation details will be added as the module is developed.*