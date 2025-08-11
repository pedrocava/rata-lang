# Macro Module

The Macro module provides metaprogramming capabilities for code generation, domain-specific languages, and compile-time transformations.

## Overview

Macro features:
- **Compile-time execution**: Run code during compilation
- **AST manipulation**: Transform code before execution
- **Code generation**: Generate repetitive code automatically
- **DSL support**: Build domain-specific languages
- **Hygiene**: Prevent variable capture issues

## Import

```rata
library Macro as m
```

## Basic Macro Definition

```rata
# Simple macro
macro unless(condition, do_block) {
  quote {
    if not unquote(condition) {
      unquote(do_block)
    }
  }
}

# Usage
unless(user.is_admin) {
  return {:error, :unauthorized}
}

# Expands to:
if not user.is_admin {
  return {:error, :unauthorized}
}
```

## Quoting and Unquoting

### `quote(expression)` - Create AST representation
### `unquote(ast)` - Insert AST into quoted expression
### `unquote_splicing(list)` - Insert list elements

```rata
# Quote captures code as AST
ast = quote { x + y }

# Unquote inserts values
value = 42
expression = quote { unquote(value) + 10 }  # Becomes: 42 + 10
```

## Code Generation

```rata
# Generate getter/setter functions
macro attr(name, default \\= nil) {
  getter_name = String.to_atom(f"get_{name}")
  setter_name = String.to_atom(f"set_{name}")
  
  quote {
    # Generate getter
    unquote(getter_name) = function() {
      Process.get(unquote(name), unquote(default))
    }
    
    # Generate setter
    unquote(setter_name) = function(value) {
      Process.put(unquote(name), value)
    }
  }
}

# Usage
attr(:user_count, 0)
attr(:current_user)

# Expands to:
# get_user_count = function() { Process.get(:user_count, 0) }
# set_user_count = function(value) { Process.put(:user_count, value) }
# get_current_user = function() { Process.get(:current_user, nil) }
# set_current_user = function(value) { Process.put(:current_user, value) }
```

## AST Inspection

### `expand(ast)` - Expand macros in AST
### `to_string(ast)` - Convert AST to string representation
### `validate(ast)` - Check AST validity

```rata
# Inspect macro expansion
original = quote { unless(condition) { do_something() } }
expanded = Macro.expand(original)
code_string = Macro.to_string(expanded)
```

## Domain-Specific Languages

```rata
# SQL-like query DSL
macro select(fields, from: table, where: condition \\= nil) {
  query_ast = quote {
    query = Query.from(unquote(table))
    query = Query.select(query, unquote(fields))
  }
  
  if condition != nil {
    query_ast = quote {
      unquote(query_ast)
      query = Query.where(query, unquote(condition))
    }
  }
  
  quote {
    unquote(query_ast)
    Repo.all(query)
  }
}

# Usage
results = select([:name, :email], 
  from: UserSchema, 
  where: age > 18
)
```

## Usage Examples

```rata
# Benchmark macro
macro benchmark(name, do_block) {
  quote {
    start_time = System.monotonic_time()
    result = unquote(do_block)
    end_time = System.monotonic_time()
    duration = end_time - start_time
    
    Log.info(f"Benchmark {unquote(name)}: {duration}ms")
    result
  }
}

# Usage
result = benchmark("data_processing") {
  large_dataset
    |> Table.filter(valid_record?/1)
    |> Table.group_by(:category)
    |> Table.summarize(count: Table.n())
}

# Retry macro with exponential backoff
macro retry(attempts, do_block) {
  quote {
    retry_impl = function(remaining_attempts, delay) {
      case remaining_attempts {
        0 -> {:error, "Max retry attempts exceeded"}
        n -> 
          case unquote(do_block) {
            {:ok, result} -> {:ok, result}
            {:error, _reason} when n > 1 -> 
              Process.sleep(delay)
              retry_impl(n - 1, delay * 2)
            {:error, reason} -> {:error, reason}
          }
      }
    }
    
    retry_impl(unquote(attempts), 100)
  }
}

# Usage
result = retry(3) {
  Http.get("https://flaky-api.example.com/data")
}
```

## Best Practices

1. **Use macros sparingly** - Functions are usually better
2. **Document macro behavior** - Show expansion examples
3. **Keep macros simple** - Complex logic belongs in functions
4. **Test macro expansions** - Verify generated code is correct
5. **Consider hygiene** - Avoid variable name conflicts
6. **Provide function alternatives** - Allow both macro and function usage

---

*This is a skeleton for the Macro module documentation. Full implementation details will be added as the metaprogramming system is developed.*