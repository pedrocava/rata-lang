# Rata Parser

A parser implementation for the Rata programming language, built with Elixir and NimbleParsec.

## Overview

This is a basic parser/AST implementation for Rata that can handle the core syntax shown in the example module:

- Module declarations: `module Name { ... }`
- Variable assignments: `name = value`
- Function definitions: `function params { body }`
- Function calls: `func(args)`
- Binary operations: `+`, `-`, `*`, `^`, `<=`, `>`
- Pipe operations: `\>`
- If expressions: `if condition { then } else { else }`
- Literals: integers, floats
- Identifiers and module references: `__module__`

## Project Structure

```
lib/
├── rata_parser.ex          # Main API module
├── rata_parser/
│   ├── ast.ex              # AST node definitions
│   ├── lexer.ex            # Tokenizer using NimbleParsec
│   └── parser.ex           # Parser using NimbleParsec
test/
├── rata_parser_test.exs    # Comprehensive tests
└── test_helper.exs
```

## Usage

```elixir
# Parse a simple module
source = """
module Test {
  x = 42
  add1 = function n: int { n + 1 }
}
"""

{:ok, ast} = RataParser.parse(source)
```

## AST Structure

The parser produces a structured AST with these main node types:

- `AST.Module` - Top-level module
- `AST.Assignment` - Variable assignments
- `AST.Function` - Function definitions
- `AST.FunctionCall` - Function calls
- `AST.BinaryOp` - Binary operations
- `AST.If` - Conditional expressions
- `AST.Literal` - Literal values
- `AST.Identifier` - Variable/function names

## Installation

Add to your `mix.exs`:

```elixir
def deps do
  [
    {:nimble_parsec, "~> 1.4"}
  ]
end
```

## Running Tests

```bash
mix test
```

## Implementation Notes

- Built with NimbleParsec for fast, composable parsing
- Handles operator precedence correctly (pipe < comparison < arithmetic < power)
- Supports both typed and untyped function parameters
- Lexer ignores comments and whitespace
- Parser produces a clean AST suitable for further compilation phases

This implementation covers the basic syntax patterns needed for the Rata language as specified in the example module.