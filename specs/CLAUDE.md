# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the specification repository for **Rata**, a new programming language designed for data engineering tasks. Rata combines the ergonomics of R's tidyverse with Python-like syntax, running on the Elixir BEAM virtual machine to leverage OTP's process model and fault tolerance.

## Language Design Philosophy

Rata is designed as a "batteries included" language with these core principles:
- **Data-first**: Built for data engineering workflows with familiar data types (vectors, tables, maps)
- **REPL-first**: Interactive development experience
- **Immutable by default**: Standard library avoids side-effects by design
- **1-indexed**: Following R conventions for data work
- **Optional typing**: `add1 = function(n: int) { n + 1 }`
- **Pattern matching**: Elixir-style case expressions with wrapped returns
- **No scalars**: Every value is a single-entry vector

## Repository Structure

This repository contains language specifications only - no implementation code yet:

- `desiderata.md` - Core language features and design goals
- `module-list.md` - Planned standard library modules (Core, Math, Stat, Table, etc.)
- `runtime-considerations.md` - Implementation notes about BEAM/OTP integration
- `samples/example-module.rata` - Sample syntax showing module definition, functions, and currying

## Key Language Features

### Syntax Highlights
- Functions: `function (a, b, c) {a + b + c}` or `~ .x + .y` (lambdas)
- Pattern matching with wrapped returns: `{:ok, table}` and `{:error, message}`
- Module references: `__module__.function_name`
- Piping: `8 \> __module__.square()`
- Recursive modules: `library datetime as dt; library datetime.timezone as tz`

### Standard Library Architecture
The planned standard library includes 22+ modules covering:
- **Data manipulation**: Table (dplyr-like), Maps, List, Vector, Enum
- **I/O**: File, Dataload (csv, xls, arrow, etc.), Json
- **Runtime**: Process (OTP wrapper), Log, Macro
- **Database**: Dabber (Ecto wrapper with Repo, Schema, Query, Changeset)
- **Utilities**: Math, Stat, Datetime (lubridate-like), Struct

## Development Context

- This is a specification-only repository - no build/test commands exist yet
- Implementation will leverage Elixir/BEAM but be written mostly in Rata itself
- Target users are data engineers familiar with Python/R workflows
- Module hierarchy should reflect folder organization
- Language is being "vibecoded into existence" with iterative design

## Working with Specifications

When editing specifications:
- Keep the data engineering use case central to design decisions
- Maintain consistency with R's 1-indexing and tidyverse ergonomics
- Ensure new features integrate well with BEAM/OTP capabilities
- Consider both interactive REPL usage and production module development