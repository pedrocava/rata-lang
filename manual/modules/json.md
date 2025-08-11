# Json Module

The Json module provides JSON parsing and generation capabilities for working with JSON data in APIs, configuration files, and data interchange.

## Overview

Json features:
- **Safe parsing**: Returns `{:ok, data}` or `{:error, reason}`
- **Type mapping**: JSON types map naturally to Rata types
- **Pretty printing**: Configurable output formatting
- **Stream support**: Handle large JSON files

## Import

```rata
library Json as j
```

## Parsing

### `decode(json_string)` - Parse JSON string
### `decode!(json_string)` - Parse JSON, raise on error
### `decode_file(path)` - Parse JSON file

```rata
# Parse JSON string
case Json.decode(json_response) {
  {:ok, data} -> process_data(data)
  {:error, reason} -> Log.error(f"JSON parse error: {reason}")
}

# Parse JSON file
config = Json.decode_file!("config.json")
```

## Generation

### `encode(data, options \\= {})` - Generate JSON string
### `encode!(data, options \\= {})` - Generate JSON, raise on error
### `encode_file(data, path, options \\= {})` - Write JSON to file

```rata
# Generate JSON
user_data = {name: "Alice", age: 30, active: true}
json_string = Json.encode!(user_data, {pretty: true})

# Write to file
results |> Json.encode_file!("output.json", {indent: 2})
```

## Type Mapping

| JSON Type | Rata Type | Example |
|-----------|-----------|----------|
| `null` | `:nil` | `nil` |
| `true`/`false` | `boolean` | `true`, `false` |
| `number` | `int` or `float` | `42`, `3.14` |
| `string` | `string` | `"hello"` |
| `array` | `vector` | `[1, 2, 3]` |
| `object` | `map` | `{key: "value"}` |

## Usage Examples

```rata
# API response handling
api_response = Http.get!("https://api.example.com/users")
users = Json.decode!(api_response.body)

processed_users = users
  |> Table.from_map()
  |> Table.filter(active == true)
  |> Table.select(["name", "email"])

# Configuration management
config = Json.decode_file!("config.json")
database_url = config.database.url
api_key = config.api.key
```

---

*This is a skeleton for the Json module documentation. Full implementation details will be added as the module is developed.*