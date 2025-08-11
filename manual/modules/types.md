# Types Module

The Types module provides static typing utilities and type annotations for building more robust Rata applications with optional type checking.

## Overview

Types features:
- **Optional typing**: Add types when you need them
- **Type annotations**: Document function parameters and return types
- **Runtime type checking**: Validate types during execution
- **Custom types**: Define your own type specifications
- **Type inference**: Automatic type detection where possible

## Import

```rata
library Types as t
```

## Basic Type Annotations

```rata
# Function with type annotations
calculate_area = function(length: float, width: float): float {
  length * width
}

# Variable with type annotation
user_count: int = 1000
user_name: string = "Alice"
scores: Vector(float) = [95.5, 87.2, 92.8]
```

## Built-in Types

### Primitive Types
- `int` - Integer numbers
- `float` - Floating-point numbers  
- `boolean` - True/false values
- `string` - Text data
- `atom` - Symbols like `:ok`, `:error`

### Collection Types
- `Vector(T)` - Homogeneous vectors
- `List(T)` - Heterogeneous lists
- `Map(K, V)` - Key-value maps
- `Set(T)` - Unique value sets
- `Table` - Columnar data structures

### Composite Types
- `{T1, T2, T3}` - Tuple types
- `T | nil` - Nullable types
- `{:ok, T} | {:error, string}` - Result types

## Type Checking Functions

### `check(value, type)` - Check if value matches type
### `assert_type(value, type)` - Assert value is of type
### `cast(value, type)` - Attempt to convert to type
### `typeof(value)` - Get runtime type of value

```rata
# Type checking
Types.check(42, :int)              # true
Types.check("hello", :int)         # false
Types.assert_type(user_id, :int)   # Raises if not int

# Type casting
Types.cast("42", :int)             # {:ok, 42}
Types.cast("invalid", :int)        # {:error, "Cannot cast to int"}
```

## Custom Type Definitions

### `define_type(name, specification)` - Define custom type
### `union_type(types)` - Create union type
### `alias_type(name, existing_type)` - Create type alias

```rata
# Custom types
EmailType = Types.define_type(:email, {
  base: :string,
  validate: ~ String.contains?(.x, "@")
})

UserIdType = Types.alias_type(:user_id, :int)

StatusType = Types.union_type([:active, :inactive, :pending])
```

## Type Guards

```rata
# Type guard functions
process_user = function(data) when Types.is_map(data) {
  # Function only accepts maps
}

calculate_total = function(amounts) when Types.is_vector(amounts, :float) {
  # Function only accepts float vectors
}
```

## Generic Types

```rata
# Generic function with type parameters
first = function(T)(list: Vector(T)): T | nil {
  case Vector.length(list) {
    0 -> nil
    _ -> Vector.get(list, 1)
  }
}

# Usage
first_number = first(int)([1, 2, 3])      # 1
first_name = first(string)(["Alice", "Bob"]) # "Alice"
```

## Usage Examples

```rata
# Typed data processing
process_sales_data = function(data: Table): {:ok, Table} | {:error, string} {
  Types.assert_type(data, :table)
  
  required_columns = [:date, :amount, :customer_id]
  
  case Table.has_columns?(data, required_columns) {
    true -> 
      processed = data
        |> Table.filter(amount > 0)
        |> Table.mutate(month: Datetime.month(date))
      {:ok, processed}
      
    false ->
      {:error, "Missing required columns"}
  }
}

# Type-safe configuration
ConfigType = Types.define_type(:config, {
  database_url: :string,
  api_key: :string,
  timeout: :int,
  debug: :boolean
})

load_config = function(path: string): {:ok, ConfigType} | {:error, string} {
  case File.read(path) {
    {:ok, content} -> 
      case Json.decode(content) {
        {:ok, data} -> Types.cast(data, ConfigType)
        {:error, reason} -> {:error, f"JSON parse error: {reason}"}
      }
    {:error, reason} -> {:error, f"File read error: {reason}"}
  }
}
```

## Type Inference

```rata
# Automatic type inference
data = [1, 2, 3, 4, 5]  # Inferred as Vector(int)
result = data |> Enum.map(~ .x * 2)  # Inferred as Vector(int)

# Mixed operations preserve most specific type
numbers = [1, 2, 3.5]  # Inferred as Vector(float)
```

## Best Practices

1. **Start simple** - Add types gradually as your codebase grows
2. **Type function boundaries** - Always type public function parameters
3. **Use union types** for flexible APIs
4. **Validate external data** - Type check data from files, APIs, user input
5. **Document with types** - Types serve as living documentation
6. **Leverage inference** - Let the compiler infer types when obvious

---

*This is a skeleton for the Types module documentation. Full implementation details will be added as the type system is developed.*