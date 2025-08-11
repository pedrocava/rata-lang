# Contributing to Rata

Thank you for your interest in contributing to Rata! This guide will help you get started with development setup, understand the codebase structure, and make meaningful contributions to the language.

## Table of Contents
- [Development Setup](#development-setup)
- [Codebase Overview](#codebase-overview)
- [Contributing Workflow](#contributing-workflow)
- [Development Guidelines](#development-guidelines)
- [Testing](#testing)
- [Documentation](#documentation)
- [Standard Library Development](#standard-library-development)
- [Language Design Process](#language-design-process)

## Development Setup

### Prerequisites
- **Elixir 1.14+** with OTP 25+
- **Git** for version control  
- **A good text editor** (VS Code, Vim, Emacs, etc.)

### Installation
```bash
# Clone the repository
git clone https://github.com/your-org/rata-lang.git
cd rata-lang

# Install Elixir dependencies
cd rata_parser
mix deps.get

# Run tests (when allowed)
# mix test

# Start the REPL
# elixir repl.exs
```

### Project Structure
```
rata-lang/
├── specs/                    # Language specifications
│   ├── desiderata.md        # Core language goals
│   ├── module-list.md       # Standard library modules
│   ├── ROADMAP.md           # Implementation roadmap
│   └── samples/             # Example Rata code
├── rata_parser/             # Parser implementation
│   ├── lib/
│   │   ├── rata_parser/     # Lexer, parser, AST
│   │   ├── rata_repl/       # REPL implementation
│   │   └── rata_modules/    # Standard library modules
│   └── test/               # Test suite
├── manual/                  # Documentation (this directory)
└── assets/                  # Logo and branding assets
```

## Codebase Overview

### Parser Architecture
The parser is built using NimbleParsec and consists of:

**Lexer** (`lib/rata_parser/lexer.ex`)
- Tokenizes Rata source code
- Handles operators, keywords, literals
- String interpolation and comments

**Parser** (`lib/rata_parser/parser.ex`)  
- Builds AST from tokens
- Handles operator precedence
- Supports all Rata syntax constructs

**AST** (`lib/rata_parser/ast.ex`)
- Defines node types: Module, Assignment, Function, etc.
- Immutable data structures
- Pattern matching support

**Main API** (`lib/rata_parser.ex`)
- Entry point with `parse/1` and `parse_repl/1`
- Error handling and reporting

### REPL Architecture
**RataRepl** (`lib/rata_repl.ex`)
- Main REPL loop
- Command handling (`:help`, `:quit`, etc.)
- Variable context management

**Evaluator** (`lib/rata_repl/evaluator.ex`) 
- AST evaluation
- Built-in function calls
- Error propagation

### Standard Library  
Each module is implemented in `lib/rata_modules/`:
- **Core** - Basic language primitives
- **Math** - Mathematical functions
- **Table** - Data manipulation  
- **File** - File system operations
- And more...

## Contributing Workflow

### 1. Choose an Issue
- Check the [GitHub Issues](https://github.com/your-org/rata-lang/issues)
- Look for issues labeled `good first issue` or `help wanted`
- Check the [ROADMAP.md](../specs/ROADMAP.md) for planned features

### 2. Fork and Branch
```bash
# Fork the repo on GitHub, then:
git clone https://github.com/YOUR-USERNAME/rata-lang.git
cd rata-lang
git checkout -b feature/your-feature-name
```

### 3. Make Your Changes
Follow the development guidelines below.

### 4. Test Your Changes
```bash
# Run the test suite
mix test

# Test specific modules
mix test test/rata_parser_test.exs

# Start REPL to test interactively
elixir repl.exs
```

### 5. Submit a Pull Request  
```bash
git add .
git commit -m "Add feature: your feature description"
git push origin feature/your-feature-name
```

Then create a pull request on GitHub.

## Development Guidelines

### Code Style
- **Elixir conventions** - Follow standard Elixir formatting
- **Descriptive names** - Use clear, descriptive function and variable names
- **Pattern matching** - Use pattern matching over conditional logic when possible
- **Documentation** - Add `@doc` annotations to all public functions

### Error Handling
- **Wrapped returns** - Use `{:ok, value}` and `{:error, reason}` patterns
- **Let it crash** - Don't over-handle errors; use supervision
- **Clear error messages** - Provide helpful error context

### Testing Strategy
- **Unit tests** - Test individual functions
- **Integration tests** - Test module interactions  
- **Property tests** - Use StreamData for property-based testing
- **Example tests** - Ensure sample code continues to work

### Commit Message Format
```
type(scope): short description

Longer explanation if needed

Closes #123
```

Types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`

## Testing

### Running Tests
```bash
# All tests
mix test

# Specific test file
mix test test/math_test.exs

# Specific test
mix test test/math_test.exs:42

# Watch mode (requires mix_test_watch)
mix test.watch
```

### Writing Tests
```elixir
# Example test file: test/new_module_test.exs
defmodule NewModuleTest do
  use ExUnit.Case
  
  describe "new_function/2" do
    test "returns expected result for valid input" do
      result = RataModules.NewModule.new_function(1, 2)
      assert result == {:ok, 3}
    end
    
    test "returns error for invalid input" do
      result = RataModules.NewModule.new_function("invalid", 2)
      assert {:error, _reason} = result
    end
  end
end
```

### Property-Based Testing
```elixir
defmodule MathPropertyTest do
  use ExUnit.Case
  use ExUnitProperties
  
  property "addition is commutative" do
    check all a <- integer(),
              b <- integer() do
      assert RataModules.Math.add(a, b) == RataModules.Math.add(b, a)
    end
  end
end
```

## Documentation

### Code Documentation
```elixir
defmodule RataModules.Example do
  @moduledoc """
  Example module demonstrating documentation standards.
  
  This module provides utilities for X, Y, and Z.
  """
  
  @doc """
  Processes input data according to specified rules.
  
  ## Parameters
  - `data`: The input data to process
  - `options`: Processing options (default: [])
  
  ## Returns
  - `{:ok, processed_data}` on success
  - `{:error, reason}` on failure
  
  ## Examples
      iex> RataModules.Example.process_data([1, 2, 3])
      {:ok, [2, 4, 6]}
  """
  def process_data(data, options \\ []) do
    # Implementation
  end
end
```

### Manual Documentation
When adding new features, update the relevant manual pages:
- Add new functions to module documentation in `manual/modules/`
- Update examples in `manual/basic-concepts.md`
- Add to feature comparison in `manual/why-rata.md`

## Standard Library Development

### Module Structure
Each standard library module should follow this pattern:

```elixir
defmodule RataModules.YourModule do
  @moduledoc """
  Brief description of what this module does.
  
  Detailed explanation, design principles, and usage patterns.
  """

  # Public API functions with wrapped returns
  @doc """
  Function documentation with examples.
  """
  def your_function(arg1, arg2) when is_valid(arg1) do
    {:ok, result}
  end
  def your_function(arg1, arg2) do
    {:error, "Invalid arguments: #{inspect(arg1)}, #{inspect(arg2)}"}
  end
  
  # Bang versions for convenience
  @doc """
  Same as your_function/2 but raises on error.
  """
  def your_function!(arg1, arg2) do
    case your_function(arg1, arg2) do
      {:ok, result} -> result
      {:error, reason} -> raise reason
    end
  end
  
  # Private helper functions
  defp is_valid(arg), do: # validation logic
end
```

### Testing Standard Library Modules
```elixir
defmodule YourModuleTest do
  use ExUnit.Case
  alias RataModules.YourModule
  
  describe "your_function/2" do
    test "success cases" do
      assert {:ok, result} = YourModule.your_function(valid_arg1, valid_arg2)
      assert result == expected_result
    end
    
    test "error cases" do
      assert {:error, _reason} = YourModule.your_function(invalid_arg1, valid_arg2)
    end
    
    test "bang version raises on error" do
      assert_raise RuntimeError, fn ->
        YourModule.your_function!(invalid_arg1, valid_arg2)
      end
    end
  end
end
```

## Language Design Process

### RFC Process
For significant language changes:

1. **Create an RFC** - Write a detailed proposal
2. **Community discussion** - Get feedback on the design
3. **Implementation** - Build a prototype
4. **Testing** - Validate with real-world examples
5. **Documentation** - Update specifications and manual

### Design Principles
Keep these principles in mind when proposing changes:

- **Data-first** - Optimize for data engineering workflows
- **Immutable by default** - Functional programming approach
- **1-indexed** - Follow R conventions for data work
- **No scalars** - Everything is a vector
- **Batteries included** - Rich standard library
- **BEAM integration** - Leverage OTP capabilities

### Example RFC Template
```markdown
# RFC: Feature Name

## Summary
Brief overview of the proposed feature.

## Motivation
Why is this needed? What problems does it solve?

## Detailed Design
Technical specification with examples.

## Drawbacks
What are the downsides?

## Alternatives
What other approaches were considered?

## Implementation Plan
How will this be implemented?
```

## Getting Help

- **GitHub Discussions** - General questions and ideas
- **GitHub Issues** - Bug reports and feature requests  
- **Discord/Slack** - Real-time chat (if available)
- **Code Review** - Ask for feedback on pull requests

## Recognition

Contributors will be recognized in:
- The `CONTRIBUTORS.md` file
- Release notes for significant contributions
- The project website (when launched)

---

We appreciate all contributions, whether they're bug fixes, new features, documentation improvements, or community support. Every contribution helps make Rata better for data engineers everywhere!