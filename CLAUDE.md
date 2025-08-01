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
  - `test/` - Test suite for parser functionality

## Common Commands

### Development (in rata_parser directory)
```bash
# Install dependencies
mix deps.get

# Run tests
mix test

# Start interactive REPL 
elixir repl.exs

# Run specific test files
mix test test/rata_parser_test.exs
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

## Development Context

- Implementation leverages Elixir/BEAM but will be written mostly in Rata itself
- Target users are data engineers familiar with Python/R workflows  
- Language is being "vibecoded into existence" with iterative design
- Keep data engineering use case central to design decisions
- Maintain consistency with R's 1-indexing and tidyverse ergonomics
- Follow the roadmap phases for systematic implementation