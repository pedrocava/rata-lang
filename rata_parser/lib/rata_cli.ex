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
  
  command :help do
    description "Show help information"
    
    run _context do
      IO.puts("Rata Programming Language CLI")
      IO.puts("")
      IO.puts("Available commands:")
      IO.puts("  repl    - Start interactive REPL")
      IO.puts("  help    - Show this help message")
      IO.puts("")
      IO.puts("Use 'rata <command> --help' for more information about a command.")
    end
  end
end