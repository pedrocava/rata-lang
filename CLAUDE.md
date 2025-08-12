# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains both the specification and initial implementation for **Rata**, a new programming language designed for data engineering tasks. Rata combines the ergonomics of R's tidyverse with Python-like syntax, running on the Elixir BEAM virtual machine to leverage OTP's process model and fault tolerance.

## Repository Structure

- `specs/` - Language specifications and design documents
  - `desiderata.md` - Core language features and design goals  
  - `module-list.md` - Planned standard library modules
  - `runtime-considerations.md` - Implementation notes about BEAM/OTP integration
  - `ROADMAP.md` - Comprehensive implementation roadmap with phased todo list
  - `samples/` - Example Rata code showing syntax
- `rata_parser/` - Elixir implementation of parser and REPL
  - `lib/rata_parser/` - Parser components (lexer, parser, AST)
  - `lib/rata_repl/` - REPL implementation with evaluator
  - `lib/rata_docs/` - Documentation generation system
  - `lib/rata_modules/` - Standard library module implementations
  - `test/` - Test suite for parser functionality
- `manual/` - High-level documentation and guides (Markdown source)

## Common Commands

**IMPORTANT: Do not run tests (`mix test`) or Elixir commands (`elixir repl.exs`) until this restriction is explicitly overridden by the user.**

### Development (in rata_parser directory)
```bash
# Install dependencies
mix deps.get

# Run tests (DO NOT RUN - RESTRICTED)
# mix test

# Start interactive REPL (DO NOT RUN - RESTRICTED)
# elixir repl.exs

# Run specific test files (DO NOT RUN - RESTRICTED)
# mix test test/rata_parser_test.exs
```

### Documentation Commands
```bash
# Extract documentation from source code
rata docs extract

# Generate documentation in all formats (markdown + PDF)
rata docs generate

# Generate only specific format
rata docs generate --format markdown
rata docs generate --format typst

# Browse documentation for a specific module
rata docs module Math
rata docs module Vector

# Search across all module documentation
rata docs search "sqrt"
rata docs search "filter"
```

### REPL Commands
- `:help` - Show help message
- `:quit` - Exit REPL
- `:clear` - Clear all variables
- `:vars` - Show defined variables

## Language Implementation Architecture

### Parser Architecture (rata_parser/)
The parser is built with NimbleParsec and consists of:

- **Lexer** (`lexer.ex`) - Tokenizes Rata source code, handles operators, keywords, literals
- **Parser** (`parser.ex`) - Builds AST from tokens with proper operator precedence
- **AST** (`ast.ex`) - Defines node types: Module, Assignment, Function, FunctionCall, BinaryOp, If, Literal, Identifier
- **Main API** (`rata_parser.ex`) - Entry point with `parse/1` and `parse_repl/1` functions

### REPL Architecture  
- **RataRepl** (`rata_repl.ex`) - Main REPL loop with command handling
- **Evaluator** (`rata_repl/evaluator.ex`) - AST evaluation with variable context

### Documentation System Architecture
- **RataDocs** (`rata_docs.ex`) - Main coordination module for documentation pipeline
- **Extractor** (`rata_docs/extractor.ex`) - Extracts `@doc` annotations from Elixir modules
- **RataParser** (`rata_docs/rata_parser.ex`) - Extracts docstrings from `.rata` source files
- **Storage** (`rata_docs/storage.ex`) - In-memory storage and querying of extracted docs
- **Generator** (`rata_docs/generator.ex`) - Generates Markdown and Typst/PDF output
- **CLI** (`rata_docs/cli.ex`) - Command-line interface for browsing and searching docs
- **Templates** (`rata_docs/templates/`) - Typst templates for professional PDF generation

### Parser Capabilities
Currently supports:
- Module declarations: `module Name { ... }`
- Variable assignments: `name = value`  
- Function definitions: `function params { body }`
- Function calls with arguments
- Binary operations: `+`, `-`, `*`, `^`, `<=`, `>`
- Pipe operations: `\>`
- If expressions: `if condition { then } else { else }`
- Literals: integers, floats
- Module references: `__module__`
- **Docstrings**: Triple-quoted strings `"""documentation"""`

## Language Design Philosophy

Rata follows these core principles:
- **Data-first**: Built for data engineering workflows
- **REPL-first**: Interactive development experience  
- **Immutable by default**: Standard library avoids side-effects
- **1-indexed**: Following R conventions for data work
- **Optional typing**: `add1 = function(n: int) { n + 1 }`
- **Pattern matching**: Elixir-style case expressions with wrapped returns
- **No scalars**: Every value is a single-entry vector

## Planned Standard Library
The specification includes 22+ modules covering data manipulation (Table, Maps, Vector), I/O (File, Dataload, Json), runtime features (Process, Log), database integration (Dabber), and utilities (Math, Stat, Datetime).

## Implementation Roadmap

The `specs/ROADMAP.md` file contains a comprehensive 6-phase implementation plan:
1. **Core Language Foundation** - Parser enhancement and basic runtime
2. **Data Structures & Collections** - Vector, List, Maps, Enum modules
3. **I/O & Data Loading** - File operations and data format support
4. **Runtime & Infrastructure** - Process management, testing, database integration
5. **Tooling Ecosystem** - Compiler, editors, distribution packages
6. **Community & Adoption** - Documentation, advanced features, ecosystem growth

## Documentation Philosophy

Rata uses a **dynamic documentation system** that prioritizes:
- **Single source of truth**: Documentation lives in code as `@doc` annotations and docstrings
- **Always synchronized**: Generated docs never drift from implementation
- **Developer experience**: `rata docs` CLI for instant access to module information
- **Multiple formats**: Markdown for web/GitHub, PDF for distribution, CLI for development
- **Minimal maintenance**: No manual function lists to update
- **Professional quality**: Typst templates for publication-ready documentation

## Development Context

- Implementation leverages Elixir/BEAM but will be written mostly in Rata itself
- Target users are data engineers familiar with Python/R workflows  
- Language is being "vibecoded into existence" with iterative design
- Keep data engineering use case central to design decisions
- Maintain consistency with R's 1-indexing and tidyverse ergonomics
- Follow the roadmap phases for systematic implementation
- **Documentation-first**: All new modules should include comprehensive docstrings