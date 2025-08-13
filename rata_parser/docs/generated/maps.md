# Maps Module

Maps module for the Rata programming language.

Provides operations for working with maps/dictionaries following
Rata's design principles:
- All values are vectors (no scalars)
- 1-indexed arrays
- Immutable by default
- Data-first philosophy

Maps in Rata support both string and atom keys interchangeably.
The API treats "key" and :key as equivalent - you can store with one and retrieve with the other.
Functions include: get, put, delete, has_key, keys, values, merge, size, empty, to_list, from_list.


## Import

```rata
library Maps
```

## Functions

### `delete(_map, key)`

_No documentation available._


### `empty(map)`

_No documentation available._


### `from_list(list)`

_No documentation available._


### `get(_map, key)`

_No documentation available._


### `has_key(_map, key)`

_No documentation available._


### `keys(map)`

_No documentation available._


### `put(_map, key, _value)`

_No documentation available._


### `size(map)`

_No documentation available._


### `to_list(map)`

_No documentation available._


### `values(map)`

_No documentation available._


### `when(get, and)`

Gets a value from a map by key.
Returns the value if the key exists, otherwise returns nil.

## Examples
    iex> Maps.get({key: "value"}, :key)
    {:ok, "value"}
    
    iex> Maps.get({key: "value"}, "key")  # Same key, different format
    {:ok, "value"}
    
    iex> Maps.get({"key" => "value"}, :key)  # Works both ways
    {:ok, "value"}
    
    iex> Maps.get({key: "value"}, :missing)
    {:ok, nil}



### `when(get, not)`

_No documentation available._


### `when(put, and)`

Puts a key-value pair into a map.
Returns a new map with the key-value pair added or updated.
Keys are normalized to atoms and any existing string/atom variants are replaced.

## Examples
    iex> Maps.put({}, :key, "value")
    {:ok, %{key: "value"}}
    
    iex> Maps.put({existing: "old"}, "existing", "new")  # Updates existing :existing
    {:ok, %{existing: "new"}}



### `when(put, not)`

_No documentation available._


### `when(delete, and)`

Deletes a key from a map.
Returns a new map with the key removed. If key doesn't exist, returns the original map.

## Examples
    iex> Maps.delete({key: "value", other: "data"}, :key)
    {:ok, %{other: "data"}}
    
    iex> Maps.delete({key: "value"}, :missing)
    {:ok, %{key: "value"}}



### `when(delete, not)`

_No documentation available._


### `when(has_key, and)`

Checks if a map has a specific key.
Returns true if the key exists in the map, false otherwise.

## Examples
    iex> Maps.has_key({key: "value"}, :key)
    {:ok, true}
    
    iex> Maps.has_key({key: "value"}, :missing)
    {:ok, false}



### `when(has_key, not)`

_No documentation available._


### `when(keys, is_map)`

Gets all keys from a map.
Returns a list of all keys in the map.

## Examples
    iex> Maps.keys({a: 1, b: 2, c: 3})
    {:ok, [:a, :b, :c]}
    
    iex> Maps.keys({})
    {:ok, []}



### `when(values, is_map)`

Gets all values from a map.
Returns a list of all values in the map.

## Examples
    iex> Maps.values({a: 1, b: 2, c: 3})
    {:ok, [1, 2, 3]}
    
    iex> Maps.values({})
    {:ok, []}



### `when(merge, and)`

Merges two maps together.
The second map's values will overwrite the first map's values for duplicate keys.

## Examples
    iex> Maps.merge({a: 1, b: 2}, {b: 3, c: 4})
    {:ok, %{a: 1, b: 3, c: 4}}
    
    iex> Maps.merge({}, {key: "value"})
    {:ok, %{key: "value"}}



### `when(merge, not)`

_No documentation available._


### `when(merge, not)`

_No documentation available._


### `when(size, is_map)`

Gets the size of a map.
Returns the number of key-value pairs in the map.

## Examples
    iex> Maps.size({a: 1, b: 2, c: 3})
    {:ok, 3}
    
    iex> Maps.size({})
    {:ok, 0}



### `when(empty, is_map)`

Checks if a map is empty.
Returns true if the map has no key-value pairs, false otherwise.

## Examples
    iex> Maps.empty({})
    {:ok, true}
    
    iex> Maps.empty({key: "value"})
    {:ok, false}



### `when(to_list, is_map)`

Converts a map to a list of key-value tuples.
Returns a list where each element is a two-element tuple {key, value}.

## Examples
    iex> Maps.to_list({a: 1, b: 2})
    {:ok, [{:a, 1}, {:b, 2}]}
    
    iex> Maps.to_list({})
    {:ok, []}



### `when(from_list, is_list)`

Creates a map from a list of key-value tuples.
Takes a list where each element is a two-element tuple {key, value}.

## Examples
    iex> Maps.from_list([{:a, 1}, {:b, 2}])
    {:ok, %{a: 1, b: 2}}
    
    iex> Maps.from_list([])
    {:ok, %{}}


