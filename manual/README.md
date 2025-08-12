# Rata Programming Language Documentation

This directory contains the comprehensive documentation system for the Rata programming language. Documentation is now dynamically generated from source code docstrings using Rata's native Elixir-based tooling.

## 📚 Documentation Structure

### Core Documentation
- **[index.md](index.md)** - Main entry point and overview
- **[why-rata.md](why-rata.md)** - Language philosophy and comparison with Python/R
- **[basic-concepts.md](basic-concepts.md)** - Core language features and syntax
- **[compiler-and-elixir.md](compiler-and-elixir.md)** - BEAM integration and runtime details
- **[contributing.md](contributing.md)** - Development and contribution guidelines

### Standard Library Reference
- **[modules/](modules/)** - Legacy manual documentation (being replaced by generated docs)
- **Generated Docs** - Automatically generated from `@doc` annotations in `rata_parser/lib/rata_modules/`

### Advanced Topics
- **[advanced/](advanced/)** - Advanced programming patterns and techniques
- **[examples/](examples/)** - Complete example applications and use cases
- **[migration/](migration/)** - Migration guides from Python, R, and other languages

## ⚡ New Documentation System

### Components
- **`rata docs` CLI** - Native Elixir tooling for documentation generation
- **Docstring extraction** - Automatic extraction from Elixir modules and Rata source
- **Multiple formats** - Markdown, Typst, and PDF generation
- **Live documentation** - Always synchronized with source code

### Features
- ✅ **Single source of truth** - Documentation lives in code docstrings
- ✅ **Always synchronized** - Generated docs never drift from implementation
- ✅ **Professional PDFs** - High-quality PDF generation using Typst templates
- ✅ **CLI integration** - Browse and search docs from command line
- ✅ **Multiple formats** - Markdown for web, PDF for distribution
- ✅ **Native tooling** - Uses Rata's own Elixir infrastructure
- ✅ **Git integration** - Auto-regenerates when modules change

## 🚀 Using the Documentation System

### Prerequisites
- **Elixir** (already required for Rata development)
- **[Typst](https://typst.app/)** for PDF generation (optional)
- **Git** for version control

### Quick Start
```bash
# Navigate to rata_parser directory
cd rata_parser

# Extract documentation from all modules
elixir -e "
  Mix.start()
  Code.require_file(\"lib/rata_docs.ex\")
  Code.require_file(\"lib/rata_docs/storage.ex\")
  Code.require_file(\"lib/rata_docs/extractor.ex\")
  Code.require_file(\"lib/rata_docs/generator.ex\")
  Code.require_file(\"lib/rata_docs/cli.ex\")
  RataDocs.Extractor.extract_all()
"

# Generate documentation in all formats
elixir -e "
  Mix.start()
  # ... load modules ...
  RataDocs.Generator.generate_all(:both)
"

# Or use the CLI when available
rata docs extract     # Extract docstrings from source
rata docs generate    # Generate markdown and PDF docs
rata docs module Math # Show documentation for Math module
rata docs search sqrt # Search for functions containing 'sqrt'
```

### Output Files
- **`docs/generated/*.md`** - Markdown documentation for each module
- **`docs/generated/index.md`** - Module index and overview
- **`docs/generated/*.pdf`** - PDF documentation (if Typst is available)

## 📖 Writing Documentation

### Docstring Guidelines in Elixir Modules
Add documentation directly to your Elixir module implementations:

```elixir
defmodule RataModules.YourModule do
  @moduledoc """
  Brief description of what this module does.
  
  Longer explanation with examples and design philosophy.
  Supports standard markdown formatting.
  """
  
  @doc """
  Function description with clear purpose.
  
  Explains parameters, return values, and provides examples.
  Use markdown for formatting - code blocks, lists, etc.
  """
  def your_function(param1, param2) do
    # Implementation
  end
end
```

### Docstring Guidelines in Rata Source
When writing `.rata` files, use triple-quoted docstrings:

```rata
module DataProcessor {
  """
  Data processing utilities for ETL pipelines.
  
  This module provides functions for loading, transforming,
  and validating data from various sources.
  """
  
  process_csv = function(filename: string) {
    """
    Processes a CSV file with data validation.
    
    Args:
      filename: Path to CSV file
    
    Returns:
      Processed data as Table
    """
    # Implementation here
  }
}
```

### Adding New Modules
1. **Elixir modules**: Add to `rata_parser/lib/rata_modules/your_module.ex`
2. **Follow existing patterns**: Look at `math.ex` or `core.ex` for structure
3. **Include @moduledoc**: Describe the module's purpose and key concepts
4. **Document all public functions**: Use @doc with examples
5. **Regenerate docs**: Run `rata docs generate` to update all documentation

## 🎨 Customization

### Typst Templates
Templates are located in `rata_parser/lib/rata_docs/templates/`:
- **`module.typ`** - Individual module documentation
- **`all_modules.typ`** - Combined documentation for all modules  
- **`manual.typ`** - Full manual template (archived from legacy system)

Customize the visual appearance:
- Colors: Rata blue theme (`#2563eb`)
- Typography: Inter / Source Sans Pro / Liberation Sans
- Layout: A4 paper, professional margins
- Components: Title page, tables, code blocks

### Generator System
The `RataDocs.Generator` module can be extended to:
- Add new output formats
- Integrate with CI/CD pipelines
- Generate cross-references and indexes
- Customize Typst compilation options

## 🔄 Integration with Language

### Automatic Documentation
- **Git hooks**: Documentation regenerates when modules change
- **CLI integration**: Browse docs without leaving terminal
- **REPL integration**: Planned `:doc` and `:help` commands
- **IDE support**: Language servers can provide inline documentation

### Migration from Manual Docs
The legacy `manual/modules/*.md` files contain valuable content that should be:
1. **Migrated to docstrings** in the corresponding Elixir modules
2. **Enhanced with examples** and better formatting
3. **Kept minimal** - focus on function signatures and core concepts
4. **Replaced gradually** as the generated docs improve

## 🚀 Development Workflow

### For Module Authors
1. Write comprehensive `@doc` annotations in your Elixir modules
2. Include examples, parameter descriptions, return values
3. Test your documentation: `rata docs module YourModule`
4. The docs will auto-regenerate when you commit changes

### For Contributors
1. Focus on improving docstrings rather than manual `.md` files
2. Use the CLI to browse and search existing documentation  
3. Verify generated docs look good in both Markdown and PDF formats
4. Consider adding examples to the `specs/samples/` directory

## 🤝 Contributing

See the main [Contributing Guide](contributing.md) for details on:
- Documentation standards
- Review process
- Writing guidelines
- Translation support

---

*The Rata documentation system leverages the language's own infrastructure to provide always-current, comprehensive documentation that grows with the codebase.*