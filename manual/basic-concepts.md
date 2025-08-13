# Basic Concepts and Examples

This guide introduces Rata's core concepts, syntax, and programming model. By the end, you'll understand how to write effective Rata code for data engineering tasks.

## Table of Contents
- [Values and Types](#values-and-types)
- [Variables and Assignment](#variables-and-assignment)  
- [Functions](#functions)
- [Modules](#modules)
- [Data Structures](#data-structures)
- [Control Flow](#control-flow)
- [Pattern Matching](#pattern-matching)
- [Pipe Operations](#pipe-operations)
- [Error Handling](#error-handling)

## Values and Types

### No Scalars - Everything is a Vector
```rata
# These all create single-element vectors
age = 25           # [25]
name = "Alice"     # ["Alice"]
active = true      # [true]
pi = 3.14159       # [3.14159]
```

### Basic Types
```rata
# Integers
count = 42
negative = -10
big_number = 1_000_000

# Floats  
price = 19.99
scientific = 1.23e-4

# Booleans
is_ready = true
is_complete = false

# Strings
greeting = "Hello, World!"
multiline = "This is a
multiline string"
triple_quotes = """
this is a string!
"""

# Symbols (atoms)
status = :ok
category = :error
something = :nice
```

## Variables and Assignment

```rata
# Simple assignment
name = "Alice"
age = 30
```

## Functions

### Function Definition
```rata
# Basic function
greet = function(name) {
  return f"Hello, {name}!"
}

# Function with type annotations
add = function(a: numeric, b: numeric) {
  return a + b
}

# Function with default parameters
# The return keyword is optional if the function's body is single expression
power = function(base, exponent: int = 2) {
  base ^ exponent
}
```

### Anonymous Functions and Lambdas
```rata
square = function(x) { x * x }

# Lambda syntax (shorthand)
double = ~ .x * 2
add_them = ~ .x + .y

# Using with collections
[1, 2, 3, 4, 5] |> Enum.map(~ .x * 2)  # [2, 4, 6, 8, 10]
```

### Higher-Order Functions
```rata
# Function that returns a function
make_multiplier = function(factor) {
  return function(x) { x * factor }
}

times_three = make_multiplier(3)
result = times_three(4)  # [12]
```

## Modules

### Module Definition
```rata
module MathUtils {
  
  pi = 3.14159
  
  circle_area = function(radius: numeric) {
    pi * radius^2
  }
  
  rectangle_area = function(width: numeric, height: numeric) {
    width * height
  }
}

# Using the module
area = MathUtils.circle_area(5)
```

### Importing Modules
```rata
# Import with alias
library Math as m
library DateTime as dt

# Use imported functions
result = m.sqrt(16)
now = dt.now()
```

### Module References
```rata
module Calculator {
  add = function(a, b) { a + b }
  
  # Reference other functions in the same module
  add_one = function(x) { __module__.add(x, 1) }
}
```

## Data Structures

### Vectors
```rata
# Vector creation
numbers = [1, 2, 3, 4, 5]
names = ["Alice", "Bob", "Charlie"]

# Vector operations (1-indexed)
first = numbers[1]        # 1
slice = numbers[2..4]     # [2, 3, 4]
last = numbers[-1]        # 5

# Vector functions
length = Vector.length(numbers)    # 5
sum = Vector.sum(numbers)          # 15
```

### Lists (Heterogeneous Collections)
```rata
# Lists can contain different types
person = {"Alice", 25, :active, true}

# Access by index
name = person[1]    # "Alice"
age = person[2]     # 25
```

### Maps
```rata
# Map creation
user = {
  id: 123,
  name: "Alice Johnson", 
  email: "alice@example.com",
  active: true
}

# Map access
user_id = user.get(:id)

# Map manipulation
updated_user = user |> 
  Maps.put(age: 30)
```

### Sets
```rata
# Set creation
tags = #{:urgent, :important, :review}

# Set operations
has_urgent = Set.member?(tags, :urgent)      # true
new_tags = Set.union(tags, #{:completed})   # #{:urgent, :important, :review, :completed}
```

### Tables (DataFrames)
```rata
# Table creation
data = Table.from_map({
  name: ["Alice", "Breno", "Carlos"],
  age: [25, 30, 35],
  city: ["Rio", "São Paulo", "Porto Alegre"],
  docs: {
    {
      cpf: 12345678910, 
      rg: 321654984
    },
    {
      cpf: 22345678911, 
      rg: 822654987},
    {
      cpf: 32345678913, 
      rg: 531654989
    }
    }
})

# Table operations (dplyr-style)
adults = data
  |> Table.filter(age >= 18)
  |> Table.select([name, age])
  |> Table.arrange(age)
```

## Control Flow

### If Expressions
```rata
# If expression (returns a value)
result = if age >= 18 {
  "adult"
} else {
  "minor"
}

# Multi-branch
category = if score >= 90 {
  "excellent"
} else if score >= 80 {
  "good"
} else if score >= 70 {
  "okay"
} else {
  "needs_improvement"
}
```

### Case Expressions (Pattern Matching)
```rata
# Pattern matching on values
process_response = function(response) {
  case response {
    {:ok, data} -> 
      Log.info(f"Success: {data}")
      data
    
    {:error, :not_found} -> 
      Log.warn("Resource not found")
      nil
    
    {:error, reason} -> 
      Log.error(f"Error: {reason}")
      raise reason
  }
}
```

## Pattern Matching

### Basic Patterns
```rata
# Match exact values
case status {
  :ok -> "All good"
  :error -> "Something went wrong"
  _ -> "Unknown status"  # wildcard
}

# Match and extract values
case user {
  {name, age} when age >= 18 -> f"Adult: {name}"
  {name, age} -> f"Minor: {name}"
}
```

### List Patterns
```rata
case numbers {
  [] -> "Empty list"
  [head | tail] -> f"First: {head}, Rest: {tail}"
  [single] -> f"Only: {single}"
}
```

### Map Patterns
```rata
case request {
  {method: :get, path: "/users"} -> get_users()
  {method: :post, path: "/users", body: data} -> create_user(data)
  _ -> {:error, :bad_request}
}
```

## Pipe Operations

### Basic Piping
```rata
# Traditional nested calls
result = Math.sqrt(Math.abs(-16))

# Piped operations (left to right)
result = -16 |> Math.abs() |> Math.sqrt()
```

### Data Pipeline Example
```rata
# Complex data transformation pipeline
processed_data = raw_data
  |> Table.filter(age > 0)
  |> Table.mutate(age_group: categorize_age(age))
  |> Table.group_by(:age_group)
  |> Table.summarize(
      count: Table.n(),
      avg_score: Math.mean(score)
     )
  |> Table.arrange(-count)
```

## Error Handling

### Wrapped Returns
```rata
# Functions return {:ok, value} or {:error, reason}
case File.read("data.csv") {
  {:ok, content} -> 
    parse_csv(content)
  
  {:error, :enoent} -> 
    Log.error("File not found")
    {:error, "Missing data file"}
    
  {:error, reason} -> 
    Log.error(f"File error: {reason}")
    {:error, "File read failed"}
}
```

### Bang Functions (Unwrapping)
```rata
# Regular wrapped function
case Dataload.read_csv("data.csv") {
  {:ok, table} -> process_table(table)
  {:error, reason} -> handle_error(reason)  
}

# Bang function (raises on error)
table = Dataload.read_csv!("data.csv")  # Raises if file doesn't exist
process_table(table)
```

### Try-Catch (Coming Soon)
```rata
# Future syntax for exception handling
result = try {
  data = Dataload.read_csv!("risky_file.csv")
  transform_data(data)
} catch {
  FileError -> default_data()
  ParseError as e -> 
    Log.error(f"Parse failed: {e}")
    nil
}
```

## Putting It All Together

Here's a complete example showing many of these concepts:

```rata
module DataProcessor {
  """
  Module for processing user data files.
  """
  
  # Process a CSV file of user data
  process_user_file = function(filename: string) {
    case Dataload.read_csv(filename) {
      {:ok, raw_data} ->
        processed = raw_data
          |> Table.filter(age > 0)           # Remove invalid ages
          |> Table.filter(email != "")       # Remove missing emails  
          |> Table.mutate(
              age_group: categorize_age(age),
              is_adult: age >= 18
             )
          |> Table.arrange([age_group, name])
        
        {:ok, processed}
      
      {:error, reason} ->
        Log.error(f"Failed to process {filename}: {reason}")
        {:error, reason}
    }
  }
  
  # Helper function to categorize ages
  categorize_age = function(age: int) {
    case age {
      n when n < 13 -> :child
      n when n < 20 -> :teen  
      n when n < 65 -> :adult
      _ -> :senior
    }
  }
}

# Usage
case DataProcessor.process_user_file("users.csv") {
  {:ok, processed_data} ->
    Log.info(f"Processed {Table.nrows(processed_data)} users")
    processed_data |> Table.write_csv("processed_users.csv")
    
  {:error, reason} ->
    Log.error("Processing failed")
    System.exit(1)
}
```

## Next Steps

- Explore the [Standard Library Modules](modules/index.md) for data manipulation functions
- Learn about [Advanced Topics](advanced/index.md) like OTP integration and concurrency
- Check out complete [Examples](examples/index.md) of real-world Rata applications