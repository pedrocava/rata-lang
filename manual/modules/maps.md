# Maps Module

The Maps module provides operations for working with key-value data structures in Rata. Maps use the syntax `{key: value, another: "value"}` and are essential for structured data.

## Overview

Maps in Rata are:
- **Key-value pairs**: Associate keys with values
- **Immutable**: Operations return new maps
- **Flexible keys**: Support atoms, strings, and other types as keys
- **Efficient**: Optimized for fast lookups and updates

## Import

```rata
library Maps as m
```

## Map Creation

### `new(pairs)` - Create map from key-value pairs
### `empty()` - Create empty map
### `from_list(list)` - Create from list of {key, value} tuples

## Core Operations

### `get(map, key, default \\ nil)` - Get value by key
### `put(map, key, value)` - Add or update key-value pair
### `delete(map, key)` - Remove key-value pair
### `has_key?(map, key)` - Check if key exists
### `keys(map)` - Get all keys as vector
### `values(map)` - Get all values as vector
### `size(map)` - Get number of key-value pairs

## Functional Operations

### `map(map, function)` - Transform all values
### `filter(map, predicate)` - Keep matching key-value pairs
### `reduce(map, function, initial)` - Reduce to single value
### `merge(map1, map2)` - Combine two maps

## Usage Examples

```rata
# User data
user = {
  id: 123,
  name: "Alice Johnson",
  email: "alice@example.com", 
  preferences: {theme: "dark", notifications: true}
}

# Access values
user_id = Maps.get(user, :id)  # 123
theme = user.preferences.theme  # "dark"

# Update values
updated_user = user |> Maps.put(:last_login, DateTime.now())
```

---

*This is a skeleton for the Maps module documentation. Full implementation details will be added as the module is developed.*