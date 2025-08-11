# List Module

The List module provides operations for working with heterogeneous ordered collections in Rata. Lists use tuple syntax `{1, "hello", :symbol}` and can contain elements of different types.

## Overview

Lists in Rata are:
- **Heterogeneous**: Can contain elements of different types
- **Ordered**: Elements maintain their position  
- **1-indexed**: Following R conventions
- **Immutable**: Operations return new lists
- **Tuple-like**: Similar to Elixir tuples in implementation

## Import

```rata
library List as l
```

## List Creation

### `new(elements)`
```rata
mixed = List.new({1, "hello", :symbol, true})
coordinates = List.new({x: 10, y: 20})
```

### `empty()`
```rata
empty_list = List.empty()
```

## Core Operations

### `length(list)` - Get number of elements
### `get(list, index)` - Access element by 1-based index
### `append(list, element)` - Add element to end
### `prepend(list, element)` - Add element to beginning
### `concat(list1, list2)` - Combine two lists
### `reverse(list)` - Reverse element order

## Functional Operations

### `map(list, function)` - Transform each element
### `filter(list, predicate)` - Keep matching elements  
### `reduce(list, function, initial)` - Reduce to single value
### `each(list, function)` - Execute function for each element (side effects)

## Pattern Matching Support

```rata
case user_data {
  {name, age, :active} -> process_active_user(name, age)
  {name, age, :inactive} -> archive_user(name, age)
  _ -> handle_unknown_format()
}
```

## Usage Examples

```rata
# Mixed data structures
person = {"Alice", 30, :engineer, {city: "NYC", state: "NY"}}

name = List.get(person, 1)     # "Alice"
age = List.get(person, 2)      # 30
role = List.get(person, 3)     # :engineer
address = List.get(person, 4)  # {city: "NYC", state: "NY"}

# Functional operations
numbers_and_strings = {1, "two", 3, "four", 5}
numbers_only = numbers_and_strings 
  |> List.filter(Core.is_number/1)  # {1, 3, 5}
```

---

*This is a skeleton for the List module documentation. Full implementation details will be added as the module is developed.*