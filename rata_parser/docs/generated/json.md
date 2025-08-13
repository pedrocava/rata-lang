# Json Module

JSON toolkit for the Rata programming language.

Provides JSON parsing, encoding, and validation following Rata's design principles:
- All values are vectors (no scalars)
- Functions with `!` suffix return wrapped results: {:ok, result} or {:error, message}
- Functions without `!` suffix return unwrapped results or raise exceptions
- Immutable by default
- Data-first philosophy
- Vectorized operations (accepts lists where applicable)

This module handles JSON operations for data engineering workflows, converting between
Rata data structures (Maps, Lists, Vectors) and JSON strings.

## Function Convention

Each operation comes in two variants:
- `function_name/arity` - Returns direct results, raises exceptions on errors
- `function_name!/arity` - Returns `{:ok, result}` or `{:error, reason}` tuples

Functions ending in `?` also have an `is_` prefixed alias:
- `valid?/1` and `is_valid/1` - Check if string is valid JSON
- `valid!/1` and `is_valid!/1` - Wrapped versions

## Examples

    # Parse JSON string
    data = Json.parse(~s|{"name": "Alice", "age": 30}|)
    # => %{"name" => "Alice", "age" => 30}
    
    # Encode data to JSON
    json = Json.encode(%{"name" => "Bob", "items" => [1, 2, 3]})
    # => ~s|{"name":"Bob","items":[1,2,3]}|
    
    # Validate JSON
    Json.valid?(~s|{"valid": true}|)  # => true
    Json.is_valid(~s|{invalid}|)       # => false
    
    # Wrapped versions for error handling
    case Json.parse!(json_string) do
      {:ok, data} -> process_data(data)
      {:error, message} -> Log.error("JSON parse failed: #{message}")
    end


## Import

```rata
library Json
```

## Functions

### `encode(invalid)`

_No documentation available._


### `encode!(invalid)`

_No documentation available._


### `encode_pretty(invalid)`

_No documentation available._


### `encode_pretty!(invalid)`

_No documentation available._


### `is_valid(json_string_or_list)`

Alias for valid?/1 - Check if a string contains valid JSON.

## Examples

    iex> Json.is_valid(~s|{"name": "Alice"}|)
    true
    
    iex> Json.is_valid(~s|{invalid json}|)
    false



### `is_valid!(json_string_or_list)`

Alias for valid!/1 - Check if a string contains valid JSON (wrapped version).

## Examples

    iex> Json.is_valid!(~s|{"name": "Alice"}|)
    {:ok, true}



### `parse(invalid)`

_No documentation available._


### `parse!(invalid)`

_No documentation available._


### `parse_file(invalid)`

_No documentation available._


### `parse_file!(invalid)`

_No documentation available._


### `valid!(invalid)`

_No documentation available._


### `valid?(invalid)`

_No documentation available._


### `when(parse, is_binary)`

Parse a JSON string to Rata data structures (unwrapped version - raises on error).

Converts JSON objects to Maps, JSON arrays to Lists, and preserves JSON primitives.

## Examples

    iex> Json.parse(~s|{"name": "Alice", "age": 30}|)
    %{"name" => "Alice", "age" => 30}
    
    iex> Json.parse(~s|[1, 2, 3]|)
    [1, 2, 3]
    
    iex> Json.parse(~s|["json1", "json2"]|)
    ["json1", "json2"]



### `when(parse, is_list)`

_No documentation available._


### `when(parse!, is_binary)`

Parse a JSON string to Rata data structures (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> Json.parse!(~s|{"name": "Alice"}|)
    {:ok, %{"name" => "Alice"}}
    
    iex> Json.parse!(~s|{invalid}|)
    {:error, "Failed to parse JSON: invalid syntax at position 1"}



### `when(parse!, is_list)`

_No documentation available._


### `when(parse_file, is_binary)`

Parse JSON from a file (unwrapped version - raises on error).

Reads the file and parses its JSON contents to Rata data structures.

## Examples

    iex> Json.parse_file("/path/to/data.json")
    %{"users" => [%{"name" => "Alice"}, %{"name" => "Bob"}]}
    
    iex> Json.parse_file(["/file1.json", "/file2.json"])
    [%{"data1" => "value1"}, %{"data2" => "value2"}]



### `when(parse_file, is_list)`

_No documentation available._


### `when(parse_file!, is_binary)`

Parse JSON from a file (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> Json.parse_file!("/path/to/data.json")
    {:ok, %{"users" => [%{"name" => "Alice"}]}}
    
    iex> Json.parse_file!("/nonexistent.json")
    {:error, "Failed to read file /nonexistent.json: enoent"}



### `when(parse_file!, is_list)`

_No documentation available._


### `when(encode, or)`

Encode Rata data to JSON string (unwrapped version - raises on error).

Converts Rata Maps to JSON objects, Lists to JSON arrays, and preserves primitives.
Uses compact formatting without indentation.

## Examples

    iex> Json.encode(%{"name" => "Alice", "age" => 30})
    ~s|{"name":"Alice","age":30}|
    
    iex> Json.encode([1, 2, 3])
    "[1,2,3]"
    
    iex> Json.encode([%{"a" => 1}, %{"b" => 2}])
    [~s|{"a":1}|, ~s|{"b":2}|]



### `when(encode, is_list)`

_No documentation available._


### `when(encode!, or)`

Encode Rata data to JSON string (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> Json.encode!(%{"name" => "Alice"})
    {:ok, ~s|{"name":"Alice"}|}
    
    iex> Json.encode!(:invalid_atom)
    {:error, "Failed to encode to JSON: cannot encode atom"}



### `when(encode!, is_list)`

_No documentation available._


### `when(encode_pretty, or)`

Encode Rata data to pretty-formatted JSON string (unwrapped version - raises on error).

Same as encode/1 but with indentation and line breaks for readability.

## Examples

    iex> Json.encode_pretty(%{"name" => "Alice", "age" => 30})
    ~s|{
      "name": "Alice",
      "age": 30
    }|



### `when(encode_pretty, is_list)`

_No documentation available._


### `when(encode_pretty!, or)`

Encode Rata data to pretty-formatted JSON string (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> Json.encode_pretty!(%{"name" => "Alice"})
    {:ok, ~s|{
  "name": "Alice"
}|}



### `when(encode_pretty!, is_list)`

_No documentation available._


### `when(write_file, is_binary)`

Write JSON data to a file (unwrapped version - raises on error).

Encodes the data to JSON and writes it to the specified file path.

## Examples

    iex> Json.write_file(%{"users" => ["Alice", "Bob"]}, "/path/to/output.json")
    "/path/to/output.json"



### `when(write_file!, is_binary)`

Write JSON data to a file (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> Json.write_file!(%{"data" => "value"}, "/path/to/output.json")
    {:ok, "/path/to/output.json"}
    
    iex> Json.write_file!(%{"data" => "value"}, "/invalid/path/file.json")
    {:error, "Failed to write JSON to file /invalid/path/file.json: enoent"}



### `when(valid?, is_binary)`

Check if a string contains valid JSON (unwrapped version - raises on error).

Returns true if the string can be parsed as valid JSON, false otherwise.

## Examples

    iex> Json.valid?(~s|{"name": "Alice"}|)
    true
    
    iex> Json.valid?(~s|{invalid json}|)
    false
    
    iex> Json.valid?([~s|{"valid": true}|, ~s|{invalid}|])
    [true, false]



### `when(valid?, is_list)`

_No documentation available._


### `when(valid!, is_binary)`

Check if a string contains valid JSON (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> Json.valid!(~s|{"name": "Alice"}|)
    {:ok, true}
    
    iex> Json.valid!(~s|{invalid json}|)
    {:ok, false}
    
    iex> Json.valid!([~s|{"valid": true}|, ~s|{invalid}|])
    {:ok, [true, false]}



### `when(valid!, is_list)`

_No documentation available._


### `write_file(data, file_path)`

_No documentation available._


### `write_file!(data, file_path)`

_No documentation available._

