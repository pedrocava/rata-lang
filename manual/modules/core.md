# Core Module

The Core module provides the fundamental building blocks of the Rata language, including basic primitives, control flow constructs, and essential utility functions.

## Overview

The Core module is automatically imported into every Rata program and provides:
- Basic data type utilities
- Control flow helpers
- Assertion functions
- Error handling primitives
- System introspection functions

## Functions

### Type Checking

#### `type_of(value)`
Returns the type of a given value as a symbol.

```rata
Core.type_of(42)        # :int
Core.type_of(3.14)      # :float  
Core.type_of("hello")   # :string
Core.type_of([1, 2, 3]) # :vector
Core.type_of({a: 1})    # :map
```

**Parameters:**
- `value` - Any value to check the type of

**Returns:**
- Symbol representing the value's type

#### `is_vector(value)`, `is_map(value)`, `is_string(value)`, etc.
Type predicate functions for each major type.

```rata
Core.is_vector([1, 2, 3])  # true
Core.is_map({key: "val"})  # true  
Core.is_string(42)         # false
```

### Assertions

#### `assert(condition, message \\ "Assertion failed")`
Validates that a condition is true, raises an error if false.

```rata
assert(age >= 0, "Age cannot be negative")
assert(Vector.length(data) > 0, "Data cannot be empty")
```

**Parameters:**
- `condition` - Boolean expression to test
- `message` - Optional error message (default: "Assertion failed")

**Returns:**
- `:ok` if assertion passes
- Raises `AssertionError` if assertion fails

#### `assert_eq(actual, expected, message \\ nil)`
Asserts that two values are equal.

```rata
assert_eq(math_result, 42, "Math calculation failed")
assert_eq(Vector.length(processed_data), expected_count)
```

#### `assert_type(value, expected_type)`
Asserts that a value is of the expected type.

```rata
assert_type(user_id, :int)
assert_type(user_data, :map)
```

### Control Flow Helpers

#### `if_let(pattern, value, then_block, else_block)`
Pattern matching with conditional execution.

```rata
result = if_let({:ok, data}, api_response) {
  process_data(data)
} else {
  handle_error()
}
```

#### `unless(condition, block)`
Execute block only if condition is false.

```rata
unless(user.is_admin) {
  Log.error("Access denied")
  return {:error, :unauthorized}
}
```

### Error Handling

#### `ok(value)`
Wraps a value in an `:ok` tuple.

```rata
result = ok(processed_data)  # {:ok, processed_data}
```

#### `error(reason)`
Creates an error tuple.

```rata
validation_result = error("Invalid email format")  # {:error, "Invalid email format"}
```

#### `unwrap(result)`
Extracts value from `{:ok, value}` tuple, raises on error.

```rata
data = unwrap(File.read("config.json"))  # Raises if file read fails
```

#### `unwrap_or(result, default)`
Extracts value from result tuple, returns default on error.

```rata
config = unwrap_or(File.read("config.json"), default_config)
```

### System Introspection

#### `module_name()`
Returns the name of the current module.

```rata
module DataProcessor {
  current_module = Core.module_name()  # :DataProcessor
}
```

#### `function_name()`
Returns the name of the current function.

```rata
debug_info = function() {
  Log.debug(f"In function: {Core.function_name()}")
}
```

#### `inspect(value, opts \\ [])`
Returns a string representation of any value for debugging.

```rata
user_data = {name: "Alice", age: 30}
Log.debug(Core.inspect(user_data))  # "{name: \"Alice\", age: 30}"
```

### Utility Functions

#### `identity(value)`
Returns the value unchanged. Useful in function composition.

```rata
[1, 2, 3] |> Enum.map(Core.identity)  # [1, 2, 3]
```

#### `tap(value, function)`
Calls function with value for side effects, returns original value.

```rata
result = expensive_computation()
  |> Core.tap(Log.debug/1)  # Log the result
  |> further_processing()
```

#### `with_default(value, default)`
Returns value if not nil, otherwise returns default.

```rata
name = Core.with_default(user.nickname, user.full_name)
```

## Usage Examples

### Basic Error Handling Pattern
```rata
process_user_data = function(user_id) {
  assert_type(user_id, :int)
  assert(user_id > 0, "User ID must be positive")
  
  case Database.get_user(user_id) {
    {:ok, user} -> 
      processed = user 
        |> Core.tap(~ Log.info(f"Processing user: {.x.name}"))
        |> transform_user_data()
      ok(processed)
      
    {:error, :not_found} -> 
      error("User not found")
      
    {:error, reason} -> 
      Log.error(f"Database error: {reason}")
      error("Database unavailable")
  }
}
```

### Validation with Assertions
```rata
validate_order = function(order) {
  assert_type(order, :map)
  assert(Maps.has_key?(order, :customer_id), "Order must have customer_id")
  assert(Maps.has_key?(order, :items), "Order must have items")
  
  items = order.items
  assert(Vector.length(items) > 0, "Order must have at least one item")
  
  Enum.each(items, fn item ->
    assert_type(item.price, :float)
    assert(item.price > 0, "Item price must be positive")
  end)
  
  ok(order)
}
```

### System Introspection
```rata
debug_function = function(input_data) {
  module_name = Core.module_name()
  function_name = Core.function_name()
  
  Log.debug(f"[{module_name}.{function_name}] Input: {Core.inspect(input_data)}")
  
  result = process_data(input_data)
  
  Log.debug(f"[{module_name}.{function_name}] Output: {Core.inspect(result)}")
  
  result
}
```

## Error Types

The Core module defines several standard error types:
- **AssertionError** - Raised by failed assertions
- **TypeError** - Raised by type validation functions  
- **ArgumentError** - Raised by invalid function arguments

## Best Practices

1. **Use assertions liberally** in development to catch errors early
2. **Wrap return values** using `ok()` and `error()` for consistent API
3. **Use `tap()`** for debugging and logging without breaking pipelines
4. **Type check inputs** at function boundaries using `assert_type()`
5. **Provide meaningful error messages** in assertions and error returns

---

The Core module forms the foundation of idiomatic Rata programming. Master these functions to write robust, debuggable Rata code.