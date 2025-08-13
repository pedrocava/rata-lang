defmodule RataCli do
  @moduledoc """
  Main CLI interface for the Rata programming language.
  
  Provides command-line tools for Rata development including REPL, 
  project management, and other development utilities.
  """
  
  use ExCLI.DSL, escript: true
  
  name "rata"
  description "Rata Programming Language CLI"
  long_description """
  Rata is a data-first programming language designed for data engineering tasks.
  This CLI provides tools for interactive development and project management.
  """
  
  option :version, help: "Show version", aliases: [:v]
  
  command :repl do
    description "Start the interactive Rata REPL"
    long_description """
    Launch the Rata Read-Eval-Print Loop for interactive programming.
    
    The REPL supports:
    - Variable assignments and expressions
    - Function definitions and calls  
    - Built-in Rata modules (Math, Core, List, etc.)
    - Special commands: :help, :quit, :clear, :vars
    """
    
    run context do
      if context.version do
        IO.puts("Rata CLI v0.1.0")
      else
        # Start the existing REPL
        RataRepl.start()
      end
    end
  end
  
  command :docs_extract do
    description "Extract docstrings from Elixir module implementations"
    
    run _context do
      RataDocs.Extractor.extract_all()
    end
  end
  
  command :docs_generate do
    description "Generate documentation files from extracted docstrings"
    option :format, help: "Output format: markdown, typst, both", default: "both"
    
    run context do
      format = String.to_atom(context.format)
      RataDocs.Generator.generate_all(format)
    end
  end
  
  command :docs_module do
    description "Show documentation for a specific module"
    argument :module_name, help: "Name of the module (e.g. Math, Vector, Table)"
    
    run context do
      RataDocs.CLI.show_module(context.module_name)
    end
  end
  
  command :docs_search do
    description "Search for functions across all modules"
    argument :query, help: "Search term or pattern"
    
    run context do
      RataDocs.CLI.search(context.query)
    end
  end

  command :help do
    description "Show help information"
    
    run _context do
      IO.puts("Rata Programming Language CLI")
      IO.puts("")
      IO.puts("Available commands:")
      IO.puts("  repl          - Start interactive REPL")
      IO.puts("  docs_extract  - Extract docstrings from modules")
      IO.puts("  docs_generate - Generate documentation files")
      IO.puts("  docs_module   - Show documentation for specific module")
      IO.puts("  docs_search   - Search for functions across modules")
      IO.puts("  help          - Show this help message")
      IO.puts("")
      IO.puts("Use 'rata <command> --help' for more information about a command.")
    end
  end
end