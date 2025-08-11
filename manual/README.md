# Rata Programming Language Documentation

This directory contains the comprehensive documentation system for the Rata programming language, including both the manual content and the tooling to generate professional PDFs and HTML documentation.

## 📚 Documentation Structure

### Core Documentation
- **[index.md](index.md)** - Main entry point and overview
- **[why-rata.md](why-rata.md)** - Language philosophy and comparison with Python/R
- **[basic-concepts.md](basic-concepts.md)** - Core language features and syntax
- **[compiler-and-elixir.md](compiler-and-elixir.md)** - BEAM integration and runtime details
- **[contributing.md](contributing.md)** - Development and contribution guidelines

### Standard Library Reference
- **[modules/](modules/)** - Complete documentation for all 24+ standard library modules
- **[modules/index.md](modules/index.md)** - Module overview and quick reference

### Advanced Topics
- **[advanced/](advanced/)** - Advanced programming patterns and techniques
- **[examples/](examples/)** - Complete example applications and use cases
- **[migration/](migration/)** - Migration guides from Python, R, and other languages

## 🔧 Documentation System

### Components
- **[template.typ](template.typ)** - Professional Typst template for PDF generation
- **[build.py](build.py)** - Python build script for documentation generation
- **Docstring integration** - Live documentation extracted from Rata source code

### Features
- ✅ **Markdown source** - Easy-to-edit documentation in Markdown format
- ✅ **Professional PDFs** - High-quality PDF generation using Typst
- ✅ **Hyperlinked navigation** - Cross-references between sections and modules
- ✅ **Syntax highlighting** - Rata code highlighting in examples
- ✅ **Modular structure** - Organized by topic and module
- 🚧 **Docstring extraction** - Automatic documentation from source code
- 📋 **HTML output** - Web-friendly documentation (planned)

## 🚀 Building Documentation

### Prerequisites
- **Python 3.8+** for the build system
- **[Typst](https://typst.app/)** for PDF generation
- **Git** for version control

### Quick Start
```bash
# Generate PDF documentation
python build.py --format pdf

# Generate Typst intermediate files
python build.py --format typst  

# Generate all formats
python build.py --format all

# Custom output directory
python build.py --output docs/build
```

### Output Files
- **`build/rata-manual.typ`** - Typst source file
- **`build/rata-manual.pdf`** - Professional PDF manual
- **`build/rata-manual.html`** - HTML documentation (planned)

## 📖 Writing Documentation

### Markdown Guidelines
- Use standard GitHub-flavored Markdown
- Code blocks should specify language: `\`\`\`rata`
- Include practical examples in each section
- Cross-reference other modules and functions
- Keep explanations concise but comprehensive

### Rata Code Examples
```rata
# Use descriptive examples
library Table as t
library Math as m

# Show real-world usage patterns
users = t.from_map({
  name: ["Alice", "Bob", "Charlie"],
  age: [25, 30, 35]
})

adults = users |> t.filter(age >= 18)
avg_age = adults.age |> m.mean()
```

### Adding New Modules
1. Create `modules/your-module.md`
2. Follow the template from existing modules
3. Add to the build order in `build.py`
4. Update `modules/index.md` with the new module

## 🎨 Customization

### Typst Template
The `template.typ` file controls the visual appearance:
- Colors: Rata blue theme (`#2563eb`)
- Typography: Source Sans Pro / Liberation Sans
- Layout: A4 paper, professional margins
- Components: Title page, TOC, headers, code blocks

### Build System
The `build.py` script can be extended to:
- Add new output formats
- Integrate with CI/CD pipelines
- Extract documentation from source code
- Generate cross-references and indexes

## 🔄 Integration with Language

### Docstring Support
Rata supports triple-quoted docstrings:

```rata
module DataProcessor {
  \"\"\"
  Data processing utilities for ETL pipelines.
  
  This module provides functions for loading, transforming,
  and validating data from various sources.
  \"\"\"
  
  process_csv = function(filename: string) {
    \"\"\"
    Processes a CSV file with data validation.
    
    Args:
      filename: Path to CSV file
    
    Returns:
      Processed data as Table
    \"\"\"
    # Implementation here
  }
}
```

### REPL Integration
```rata
# Access documentation in REPL
:doc Math.sqrt        # Show function documentation
:help Table           # Show module overview
```

## 📋 TODO

- [ ] Implement HTML output generation
- [ ] Add docstring extraction from source code
- [ ] Create automated cross-reference generation
- [ ] Add search functionality to HTML docs
- [ ] Integrate with GitHub Pages deployment
- [ ] Add multi-language support
- [ ] Create interactive code examples

## 🤝 Contributing

See the main [Contributing Guide](contributing.md) for details on:
- Documentation standards
- Review process
- Writing guidelines
- Translation support

---

*This documentation system is designed to grow with the Rata language, providing comprehensive, professional documentation that serves both beginners and advanced users.*