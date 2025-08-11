#!/usr/bin/env python3
"""
Documentation build script for Rata Programming Language Manual.

This script converts markdown documentation to Typst format and generates PDFs.
Requires Python 3.8+ and Typst compiler.

Usage:
    python build.py [--format pdf|typst|html] [--output OUTPUT_DIR]
"""

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Optional

class RataDocBuilder:
    """Main documentation builder for Rata manual."""
    
    def __init__(self, source_dir: Path, output_dir: Path):
        self.source_dir = Path(source_dir)
        self.output_dir = Path(output_dir)
        self.template_file = self.source_dir / "template.typ"
        
    def build_all(self, formats: List[str]) -> bool:
        """Build documentation in all specified formats."""
        success = True
        
        if "pdf" in formats or "typst" in formats:
            success &= self.build_typst()
            
        if "pdf" in formats:
            success &= self.build_pdf()
            
        if "html" in formats:
            success &= self.build_html()
            
        return success
    
    def build_typst(self) -> bool:
        """Convert markdown to Typst format."""
        print("🔄 Converting markdown to Typst...")
        
        try:
            # Create output directory
            self.output_dir.mkdir(parents=True, exist_ok=True)
            
            # Read and process all markdown files
            content = self.collect_markdown_content()
            
            # Convert to Typst
            typst_content = self.markdown_to_typst(content)
            
            # Write main Typst file
            output_file = self.output_dir / "rata-manual.typ"
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(typst_content)
                
            print(f"✅ Typst file generated: {output_file}")
            return True
            
        except Exception as e:
            print(f"❌ Error building Typst: {e}")
            return False
    
    def build_pdf(self) -> bool:
        """Generate PDF from Typst file."""
        print("🔄 Generating PDF...")
        
        typst_file = self.output_dir / "rata-manual.typ"
        pdf_file = self.output_dir / "rata-manual.pdf"
        
        if not typst_file.exists():
            print("❌ Typst file not found. Run --format typst first.")
            return False
            
        try:
            # Run Typst compiler
            result = subprocess.run([
                "typst", "compile",
                str(typst_file),
                str(pdf_file)
            ], capture_output=True, text=True, check=True)
            
            print(f"✅ PDF generated: {pdf_file}")
            return True
            
        except subprocess.CalledProcessError as e:
            print(f"❌ Error generating PDF: {e}")
            print(f"Typst output: {e.stdout}")
            print(f"Typst errors: {e.stderr}")
            return False
        except FileNotFoundError:
            print("❌ Typst compiler not found. Please install Typst.")
            return False
    
    def build_html(self) -> bool:
        """Generate HTML documentation."""
        print("🔄 Generating HTML...")
        
        try:
            # This could use pandoc or a custom markdown processor
            print("📝 HTML generation not yet implemented")
            return True
            
        except Exception as e:
            print(f"❌ Error building HTML: {e}")
            return False
    
    def collect_markdown_content(self) -> Dict[str, str]:
        """Collect and organize all markdown content."""
        content = {}
        
        # Define document structure and order
        structure = [
            ("index.md", "Introduction"),
            ("why-rata.md", "Why Rata?"),
            ("basic-concepts.md", "Basic Concepts and Examples"),
            ("compiler-and-elixir.md", "The Rata Compiler and Elixir"),
            ("modules/index.md", "Standard Library Modules"),
            ("modules/core.md", "Core Module"),
            ("modules/math.md", "Math Module"),
            ("modules/table.md", "Table Module"),
            ("modules/vector.md", "Vector Module"),
            ("modules/list.md", "List Module"),
            ("modules/maps.md", "Maps Module"),
            ("modules/set.md", "Set Module"),
            ("modules/enum.md", "Enum Module"),
            ("modules/file.md", "File Module"),
            ("modules/dataload.md", "Dataload Module"),
            ("modules/datetime.md", "Datetime Module"),
            ("modules/json.md", "Json Module"),
            ("modules/process.md", "Process Module"),
            ("modules/log.md", "Log Module"),
            ("modules/stats.md", "Stats Module"),
            ("modules/tests.md", "Tests Module"),
            ("modules/module.md", "Module System"),
            ("modules/struct.md", "Struct Module"),
            ("modules/dabber.md", "Dabber Module"),
            ("modules/types.md", "Types Module"),
            ("modules/macro.md", "Macro Module"),
            ("advanced/index.md", "Advanced Topics"),
            ("examples/index.md", "Examples"),
            ("migration/index.md", "Migration Guides"),
            ("contributing.md", "Contributing to Rata")
        ]
        
        for file_path, title in structure:
            full_path = self.source_dir / file_path
            if full_path.exists():
                with open(full_path, 'r', encoding='utf-8') as f:
                    content[title] = f.read()
            else:
                print(f"⚠️  File not found: {full_path}")
                
        return content
    
    def markdown_to_typst(self, content: Dict[str, str]) -> str:
        """Convert markdown content to Typst format."""
        
        # Start with template import
        typst_content = []
        typst_content.append('#import "template.typ": *')
        typst_content.append('')
        typst_content.append('#show: rata-manual.with(')
        typst_content.append('  title: "Rata Programming Language Manual",')
        typst_content.append('  subtitle: "A Data Engineering Language",')
        typst_content.append('  version: "0.0.1-alpha",')
        typst_content.append('  author: "The Rata Team"')
        typst_content.append(')')
        typst_content.append('')
        
        # Convert each section
        for title, markdown in content.items():
            typst_section = self.convert_markdown_section(markdown, title)
            typst_content.append(typst_section)
            typst_content.append('')
            
        return '\\n'.join(typst_content)
    
    def convert_markdown_section(self, markdown: str, title: str) -> str:
        """Convert a markdown section to Typst format."""
        lines = markdown.split('\\n')
        typst_lines = []
        in_code_block = False
        code_lang = ""
        
        for line in lines:
            # Code blocks
            if line.startswith('```'):
                if in_code_block:
                    typst_lines.append('```')
                    in_code_block = False
                else:
                    # Extract language
                    parts = line[3:].strip()
                    if parts:
                        code_lang = parts
                        if code_lang == 'rata':
                            typst_lines.append('#rata-code[```rata')
                        else:
                            typst_lines.append(f'```{code_lang}')
                    else:
                        typst_lines.append('```')
                    in_code_block = True
                continue
                
            if in_code_block:
                typst_lines.append(line)
                continue
            
            # Headers - convert to Typst headings
            if line.startswith('#'):
                level = len(line) - len(line.lstrip('#'))
                heading_text = line.lstrip('#').strip()
                typst_lines.append(f"{'=' * level} {heading_text}")
                continue
            
            # Inline code
            line = re.sub(r'`([^`]+)`', r'#raw("\\1")', line)
            
            # Bold text
            line = re.sub(r'\\*\\*([^*]+)\\*\\*', r'*\\1*', line)
            
            # Italic text  
            line = re.sub(r'\\*([^*]+)\\*', r'_\\1_', line)
            
            # Links - basic conversion
            line = re.sub(r'\\[([^\\]]+)\\]\\(([^)]+)\\)', r'#link("\\2")[\\1]', line)
            
            # Tables - basic support
            if '|' in line and line.strip().startswith('|'):
                # Convert table rows
                cells = [cell.strip() for cell in line.split('|')[1:-1]]
                typst_line = '  (' + ', '.join(f'[{cell}]' for cell in cells) + '),'
                if not any('table(' in tl for tl in typst_lines[-3:]):
                    typst_lines.append('#table(')
                    typst_lines.append('  columns: {},'.format(len(cells)))
                typst_lines.append(typst_line)
                continue
            elif typst_lines and any('table(' in tl for tl in typst_lines[-3:]) and line.strip() == '':
                typst_lines.append(')')
            
            # Regular paragraphs
            if line.strip():
                typst_lines.append(line)
            else:
                typst_lines.append('')
        
        return '\\n'.join(typst_lines)

def main():
    parser = argparse.ArgumentParser(
        description="Build Rata Programming Language Documentation"
    )
    parser.add_argument(
        "--format",
        choices=["pdf", "typst", "html", "all"],
        default="all",
        help="Output format (default: all)"
    )
    parser.add_argument(
        "--output",
        type=Path,
        default="build",
        help="Output directory (default: build)"
    )
    parser.add_argument(
        "--source",
        type=Path,
        default=".",
        help="Source directory (default: current directory)"
    )
    
    args = parser.parse_args()
    
    # Determine formats to build
    if args.format == "all":
        formats = ["typst", "pdf"]
    else:
        formats = [args.format]
    
    print("🚀 Building Rata Documentation")
    print(f"📁 Source: {args.source}")
    print(f"📁 Output: {args.output}")
    print(f"📋 Formats: {', '.join(formats)}")
    print()
    
    builder = RataDocBuilder(args.source, args.output)
    
    success = builder.build_all(formats)
    
    if success:
        print("\\n✅ Documentation build completed successfully!")
        print(f"📖 Output files available in: {args.output}")
    else:
        print("\\n❌ Documentation build failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()