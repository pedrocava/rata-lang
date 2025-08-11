# Math Module

The Math module provides arithmetic operators and mathematical functions for numerical computations in Rata, following the language's vector-first approach.

## Overview

All Math functions operate on numeric vectors and follow Rata's core principles:
- **No scalars**: All numeric values are single-element vectors
- **Element-wise operations**: Operations apply to corresponding elements
- **Wrapped returns**: Functions return `{:ok, result}` or `{:error, reason}`
- **Type safety**: Clear error messages for invalid inputs

## Import

```rata
library Math as m
```

## Basic Arithmetic

### `add(a, b)`
Addition operation with type checking.

```rata
Math.add(5, 3)          # {:ok, 8}
Math.add([1, 2], [3, 4]) # {:ok, [4, 6]}
Math.add("invalid", 2)   # {:error, "Math.add requires numeric arguments..."}
```

### `subtract(a, b)`
Subtraction operation.

```rata
Math.subtract(10, 3)     # {:ok, 7}
Math.subtract([5, 8], [2, 3]) # {:ok, [3, 5]}
```

### `multiply(a, b)`
Multiplication operation.

```rata
Math.multiply(6, 7)      # {:ok, 42}
Math.multiply([2, 3], [4, 5]) # {:ok, [8, 15]}
```

### `divide(a, b)`
Division operation with zero-division protection.

```rata
Math.divide(10, 2)       # {:ok, 5.0}
Math.divide(10, 0)       # {:error, "Division by zero"}
Math.divide([8, 12], [2, 4]) # {:ok, [4.0, 3.0]}
```

### `power(base, exponent)`
Exponentiation operation.

```rata
Math.power(2, 3)         # {:ok, 8}
Math.power([2, 3], [3, 2]) # {:ok, [8, 9]}
Math.power(2, -1)        # {:ok, 0.5}
```

## Advanced Mathematical Functions

### `sqrt(number)`
Square root calculation.

```rata
Math.sqrt(16)            # {:ok, 4.0}
Math.sqrt([4, 9, 16])    # {:ok, [2.0, 3.0, 4.0]}
Math.sqrt(-1)            # {:error, "Cannot take square root of negative number"}
```

### `abs(number)`
Absolute value calculation.

```rata
Math.abs(-5)             # {:ok, 5}
Math.abs([-3, 0, 4])     # {:ok, [3, 0, 4]}
```

### `round(number, digits \\ 0)`
Round numbers to specified decimal places.

```rata
Math.round(3.14159)      # {:ok, 3}
Math.round(3.14159, 2)   # {:ok, 3.14}
Math.round([1.6, 2.3], 0) # {:ok, [2, 2]}
```

### `floor(number)`
Round down to nearest integer.

```rata
Math.floor(3.7)          # {:ok, 3}
Math.floor([-2.3, 4.8])  # {:ok, [-3, 4]}
```

### `ceil(number)`
Round up to nearest integer.

```rata
Math.ceil(3.2)           # {:ok, 4}
Math.ceil([-2.3, 4.1])   # {:ok, [-2, 5]}
```

## Trigonometric Functions

### `sin(radians)`, `cos(radians)`, `tan(radians)`
Basic trigonometric functions.

```rata
Math.sin(0)              # {:ok, 0.0}
Math.cos(Math.pi!)       # {:ok, -1.0}
Math.tan(Math.pi! / 4)   # {:ok, 1.0}
```

### `asin(value)`, `acos(value)`, `atan(value)`
Inverse trigonometric functions.

```rata
Math.asin(1)             # {:ok, 1.5707963267948966} (π/2)
Math.acos(0)             # {:ok, 1.5707963267948966} (π/2)
Math.atan(1)             # {:ok, 0.7853981633974483} (π/4)
```

## Logarithmic Functions

### `log(number, base \\ :e)`
Logarithm with configurable base.

```rata
Math.log(10)             # {:ok, 2.302585092994046} (natural log)
Math.log(100, 10)        # {:ok, 2.0} (log base 10)
Math.log(8, 2)           # {:ok, 3.0} (log base 2)
Math.log(0)              # {:error, "Cannot take logarithm of zero or negative number"}
```

### `log10(number)`
Base-10 logarithm (common logarithm).

```rata
Math.log10(1000)         # {:ok, 3.0}
Math.log10([10, 100])    # {:ok, [1.0, 2.0]}
```

### `log2(number)`
Base-2 logarithm (binary logarithm).

```rata
Math.log2(8)             # {:ok, 3.0}
Math.log2([2, 4, 8])     # {:ok, [1.0, 2.0, 3.0]}
```

## Constants

### `pi`
The mathematical constant π.

```rata
circle_area = Math.pi * radius^2
```

### `e`
The mathematical constant e (Euler's number).

```rata
exponential_growth = initial_value * Math.e^(rate * time)
```

## Statistical Functions

### `min(numbers)`, `max(numbers)`
Find minimum and maximum values.

```rata
Math.min([3, 1, 4, 1, 5]) # {:ok, 1}
Math.max([3, 1, 4, 1, 5]) # {:ok, 5}
```

### `sum(numbers)`
Sum all values in a vector.

```rata
Math.sum([1, 2, 3, 4, 5]) # {:ok, 15}
Math.sum([])              # {:ok, 0}
```

### `mean(numbers)`
Calculate arithmetic mean.

```rata
Math.mean([2, 4, 6, 8])   # {:ok, 5.0}
Math.mean([])             # {:error, "Cannot calculate mean of empty vector"}
```

## Bang Functions (!)

All Math functions have bang variants that unwrap results or raise exceptions:

```rata
# Instead of pattern matching
case Math.sqrt(16) {
  {:ok, result} -> result
  {:error, reason} -> raise reason
}

# Use bang function
result = Math.sqrt!(16)  # Returns 4.0 directly, raises on error
```

## Vector Operations

### Element-wise Operations
```rata
a = [1, 2, 3]
b = [4, 5, 6]

Math.add!(a, b)          # [5, 7, 9]
Math.multiply!(a, b)     # [4, 10, 18]
Math.power!(a, [2, 2, 2]) # [1, 4, 9]
```

### Broadcasting (Future Feature)
```rata
# Planned: Operations between vectors and scalars
Math.add!([1, 2, 3], 10) # [11, 12, 13]
Math.multiply!([2, 4, 6], 0.5) # [1.0, 2.0, 3.0]
```

## Usage Examples

### Basic Calculations
```rata
library Math as m

# Calculate compound interest
principal = 1000
rate = 0.05
years = 10

amount = principal * m.power!(1 + rate, years)
# amount = 1628.89
```

### Data Analysis
```rata
# Analyze temperature data
temperatures = [23.5, 25.1, 22.8, 26.3, 24.7, 23.9]

avg_temp = m.mean!(temperatures)
min_temp = m.min!(temperatures)
max_temp = m.max!(temperatures)
temp_range = m.subtract!(max_temp, min_temp)

Log.info(f"Average: {avg_temp}°C, Range: {temp_range}°C")
```

### Trigonometric Calculations
```rata
# Calculate distance using law of cosines
a = 5
b = 7
angle_c = m.pi! / 3  # 60 degrees in radians

c_squared = m.add!(
  m.power!(a, 2),
  m.power!(b, 2)
) |> m.subtract!(
  m.multiply!(2, m.multiply!(a, b)) |> m.multiply!(m.cos!(angle_c))
)

distance = m.sqrt!(c_squared)
```

## Error Handling Patterns

### Graceful Error Handling
```rata
safe_divide = function(numerator, denominator) {
  case Math.divide(numerator, denominator) {
    {:ok, result} -> result
    {:error, "Division by zero"} -> 
      Log.warn("Division by zero encountered, returning infinity")
      :infinity
    {:error, reason} -> 
      Log.error(f"Math error: {reason}")
      :error
  }
}
```

### Validation Pipeline
```rata
validate_and_calculate = function(input_data) {
  input_data
    |> Core.tap(~ assert(Vector.length(.x) > 0, "Data cannot be empty"))
    |> Core.tap(~ assert(Enum.all?(.x, Core.is_number/1), "All values must be numeric"))
    |> Math.sum!()
    |> Math.divide!(Vector.length(input_data))
}
```

## Best Practices

1. **Use bang functions** for simple cases where you want to fail fast
2. **Handle division by zero** explicitly in your application logic  
3. **Validate inputs** before mathematical operations
4. **Use appropriate precision** - round results when displaying to users
5. **Consider overflow** for very large numbers
6. **Use constants** like `Math.pi` instead of hardcoding approximations

## Type Requirements

- **Numeric types**: `int`, `float` (and their vector forms)
- **Error conditions**: Non-numeric inputs, mathematical domain errors
- **Return types**: Always vectors, even for single values

---

The Math module provides the foundation for all numerical computations in Rata. Combined with other modules like Stat and Vector, it enables powerful mathematical data processing workflows.