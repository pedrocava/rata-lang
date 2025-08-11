# Rata Language Manual

Welcome to the comprehensive manual for the Rata programming language - a data engineering language that combines R's tidyverse ergonomics with Python-like syntax, running on the Elixir BEAM virtual machine.

## Table of Contents

### Getting Started
- [Why Rata?](why-rata.md) - Language philosophy and comparison with Python/R
- [Basic Concepts and Examples](basic-concepts.md) - Core language features and syntax
- [Installation and Setup](installation.md) - Getting Rata running on your system

### Language Reference
- [Standard Library Modules](modules/index.md) - Complete reference for all built-in modules
- [Advanced Topics](advanced/index.md) - Pattern matching, OTP integration, and more
- [The Rata Compiler and Elixir](compiler-and-elixir.md) - BEAM integration and runtime details

### Learning Resources  
- [Examples](examples/index.md) - Complete example projects and use cases
- [Migration Guides](migration/index.md) - Moving from Python/R to Rata

### Contributing
- [Contributing to Rata](contributing.md) - Development setup and contribution guidelines

---

## Quick Reference

### Key Features
- **Data-first**: Built specifically for data engineering workflows
- **1-indexed**: Following R conventions for data work  
- **No scalars**: Every value is a vector (even single values)
- **Immutable by default**: Functional programming approach
- **REPL-first**: Interactive development experience
- **Pattern matching**: Elixir-style error handling with `{:ok, result}` and `{:error, message}`
- **Optional typing**: Add types when you need them: `function(n: int) { n + 1 }`

### Hello World
```rata
# Traditional hello world
Log.info("Hello, World!")

# More idiomatic Rata - working with data
library Table as t
library Math as m

data = t.from_map({
  name: ["Alice", "Bob", "Charlie"],
  age: [25, 30, 35]
})

data
  |> t.mutate(age_next_year: age + 1)
  |> t.filter(age > 28)
  |> Log.info()
```

### Standard Library Overview
- **[Core](modules/core.md)** - Basic language primitives and control flow
- **[Math](modules/math.md)** - Mathematical functions and operators
- **[Table](modules/table.md)** - Data manipulation with dplyr-like API
- **[Vector](modules/vector.md)** & **[List](modules/list.md)** - Collection operations
- **[File](modules/file.md)** & **[Dataload](modules/dataload.md)** - File I/O and data loading
- **[Process](modules/process.md)** - OTP process management for concurrency
- **[Log](modules/log.md)** - Logging and debugging tools

---

*This manual is generated from the Rata source code and specifications. For the most up-to-date information, see the [Rata GitHub repository](https://github.com/your-org/rata-lang).*