# Standard Library Modules

Rata's standard library provides a comprehensive set of modules for data engineering tasks. All modules follow Rata's core principles: immutability by default, 1-indexed arrays, and no scalar values.

## Module Categories

### Core Language
- **[Core](core.md)** - Basic language primitives, control flow, and assertions
- **[Module](module.md)** - Module definition and import/export system  
- **[Types](types.md)** - Static typing utilities and type annotations

### Data Structures
- **[Vector](vector.md)** - Ordered collections of same-type values `[1, 2, 3]`
- **[List](list.md)** - Ordered collections of mixed-type values `{1, :two, "three"}`
- **[Maps](maps.md)** - Key-value data structures `{key: value}`
- **[Set](set.md)** - Immutable set operations `#{1, 2, 3}`
- **[Table](table.md)** - Columnar data with dplyr-like API
- **[Struct](struct.md)** - Structured data types with schemas

### Mathematical Operations  
- **[Math](math.md)** - Arithmetic operators and mathematical functions
- **[Stat](stats.md)** - Statistical functions (mean, median, standard deviation)

### Functional Programming
- **[Enum](enum.md)** - Generic operations over collections (map, reduce, filter)

### I/O and Data Loading
- **[File](file.md)** - File system operations (read, write, exists)  
- **[Dataload](dataload.md)** - Data format readers (CSV, Excel, Parquet, Arrow)
- **[Json](json.md)** - JSON parsing and generation

### Date and Time
- **[Datetime](datetime.md)** - Date/time manipulation (lubridate-style API)

### System and Runtime
- **[Process](process.md)** - OTP process management and concurrency
- **[Log](log.md)** - Structured logging with multiple levels

### Testing and Development
- **[Tests](tests.md)** - Testing framework with assertions and organization

### Database Integration  
- **[Dabber](dabber.md)** - Database operations (Ecto wrapper)
  - **Dabber.Repo** - Connection management
  - **Dabber.Schema** - Schema definitions  
  - **Dabber.Query** - Query building
  - **Dabber.Changeset** - Data validation

### Metaprogramming
- **[Macro](macro.md)** - Macro programming toolkit for code generation

---

## Module Convention

All standard library modules follow these conventions:

### Function Naming
- **Regular functions** return `{:ok, result}` or `{:error, reason}`
- **Bang functions** (ending in `!`) unwrap results or raise exceptions

```rata
# Wrapped version
case Math.divide(10, 0) {
  {:ok, result} -> Log.info(f"Result: {result}")
  {:error, reason} -> Log.error(f"Error: {reason}")
}

# Bang version (raises on error)
result = Math.divide!(10, 2)  # Returns 5 directly
```

### Error Handling
All modules use consistent error patterns:
- **File not found**: `{:error, :enoent}`
- **Invalid arguments**: `{:error, "Invalid arguments: #{inspect(args)}"}`  
- **Type errors**: `{:error, "Expected #{expected_type}, got #{actual_type}"}`

### Documentation Standards
Each module includes:
- **Module overview** with purpose and key concepts
- **Function documentation** with parameters, return values, and examples
- **Usage patterns** showing idiomatic Rata code
- **Error handling** examples and best practices

### Import Patterns
Standard import aliases:
```rata
library Math as m
library Table as t  
library Vector as v
library Datetime as dt
library Process as p
library Log as log
```

---

## Implementation Status

✅ **Implemented** - Basic functionality available  
🚧 **In Progress** - Partial implementation  
⏳ **Planned** - Design complete, implementation pending  
💭 **Proposed** - Under design consideration

| Module | Status | Description |
|--------|--------|-------------|
| [Core](core.md) | ✅ | Basic primitives and control flow |
| [Math](math.md) | ✅ | Arithmetic and mathematical functions |
| [Set](set.md) | ✅ | Set operations and membership testing |
| [Datetime](datetime.md) | 🚧 | Date/time parsing and manipulation |
| [File](file.md) | 🚧 | File system operations |
| [List](list.md) | 🚧 | List operations and transformations |
| [Maps](maps.md) | 🚧 | Map operations and key-value manipulation |
| [Table](table.md) | 🚧 | Basic table operations |
| [Stats](stats.md) | 🚧 | Statistical function foundations |
| [Enum](enum.md) | 🚧 | Collection iteration patterns |
| [Log](log.md) | 🚧 | Basic logging functionality |
| [Vector](vector.md) | ⏳ | Vector operations and transformations |
| [Module](module.md) | ⏳ | Import/export system |
| [Dataload](dataload.md) | ⏳ | CSV and data format readers |
| [Json](json.md) | ⏳ | JSON processing |
| [Process](process.md) | ⏳ | OTP integration |
| [Tests](tests.md) | ⏳ | Testing framework |
| [Struct](struct.md) | ⏳ | Structured data types |
| [Dabber](dabber.md) | ⏳ | Database operations |
| [Types](types.md) | 💭 | Type system utilities |
| [Macro](macro.md) | 💭 | Metaprogramming tools |

---

## Quick Examples

### Data Pipeline with Multiple Modules
```rata
library Table as t
library Dataload as dl  
library Math as m
library Log as log

# Load and process data
result = dl.read_csv("sales_data.csv")
  |> t.filter(amount > 0)
  |> t.mutate(
      amount_usd: amount * exchange_rate,
      profit_margin: m.round((revenue - cost) / revenue * 100, 2)
     )
  |> t.group_by(:region)  
  |> t.summarize(
      total_sales: m.sum(amount_usd),
      avg_margin: m.mean(profit_margin)
     )
  |> t.arrange(-total_sales)

log.info(f"Processed {t.nrows(result)} regions")
```

### Concurrent Processing
```rata  
library Process as p
library Enum as e

files = ["data1.csv", "data2.csv", "data3.csv"]

results = files
  |> e.map(~ p.async(fn -> process_file(.x) end))
  |> e.map(p.await/1)
  |> combine_results()
```

For detailed documentation on each module, click the links above or explore the individual module pages.