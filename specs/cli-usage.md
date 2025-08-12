# Rata CLI Usage Guide

This document summarizes the available command-line interface for the Rata programming language.

## Prerequisites

- Elixir installed on your system
- Navigate to the `rata_parser/` directory
- Ensure dependencies are installed with `mix deps.get` (if needed)

## Available Commands

### Documentation Commands

The Rata CLI provides comprehensive documentation management:

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

### REPL (Interactive Mode)

Start an interactive Rata session:

```bash
# Start the REPL
elixir repl.exs
```

#### REPL Commands

Once in the REPL:

- `:help` - Show help message
- `:quit` - Exit REPL
- `:clear` - Clear all variables
- `:vars` - Show defined variables

### Development Commands

For development and testing:

```bash
# Install dependencies (if needed)
mix deps.get

# Run tests (when available)
mix test

# Run specific test files
mix test test/rata_parser_test.exs
```

## Documentation System Architecture

The Rata documentation system operates on a **single source of truth** principle:

- **Extraction**: Pulls `@doc` annotations from Elixir modules and docstrings from `.rata` files
- **Storage**: Maintains in-memory documentation database
- **Generation**: Produces Markdown for web/GitHub and PDF via Typst templates
- **CLI**: Provides instant access to module information during development

## Current Status

- **Manual Documentation**: Comprehensive guides available in `manual/` directory
- **Sample Code**: Working examples in `specs/samples/` showing language syntax
- **Module Documentation**: Generated from source code annotations
- **PDF Generation**: Professional documentation via Typst templates

## Files and Locations

- **Manual docs**: `manual/` - Human-written guides and concepts
- **Generated docs**: Output from `rata docs generate` commands
- **Sample code**: `specs/samples/*.rata` - Example Rata programs
- **Module source**: `lib/rata_modules/` - Standard library implementations