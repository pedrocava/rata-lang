defmodule RataDocs.CLI do
  @moduledoc """
  Command-line interface for interacting with Rata documentation.
  
  Provides user-friendly output for viewing module documentation
  and searching functions from the command line.
  """
  
  @doc """
  Display documentation for a specific module.
  """
  def show_module(module_name) do
    case RataDocs.Storage.get_module(module_name) do
      nil ->
        IO.puts("Module '#{module_name}' not found.")
        suggest_modules(module_name)
        
      module_doc ->
        display_module(module_doc)
    end
  end
  
  @doc """
  Search for functions across all modules.
  """
  def search(query) do
    results = RataDocs.Storage.search_functions(query)
    
    case results do
      [] ->
        IO.puts("No functions found matching '#{query}'")
        
      functions ->
        IO.puts("Functions matching '#{query}':")
        IO.puts(String.duplicate("=", 40))
        
        functions
        |> Enum.group_by(& &1.module)
        |> Enum.each(fn {module, module_functions} ->
          IO.puts("\n#{module}:")
          Enum.each(module_functions, &display_function_brief/1)
        end)
    end
  end
  
  defp display_module(module_doc) do
    IO.puts("#{module_doc.name} Module")
    IO.puts(String.duplicate("=", String.length(module_doc.name) + 7))
    
    if module_doc.module_doc do
      IO.puts("\n#{module_doc.module_doc}")
    end
    
    if length(module_doc.functions) > 0 do
      IO.puts("\nFunctions:")
      IO.puts(String.duplicate("-", 10))
      
      module_doc.functions
      |> Enum.sort_by(& &1.name)
      |> Enum.each(&display_function/1)
    else
      IO.puts("\nNo functions documented.")
    end
  end
  
  defp display_function(function) do
    args_str = Enum.join(function.args, ", ")
    IO.puts("\n#{function.name}(#{args_str})")
    
    if function.doc do
      # Clean up docstring formatting
      clean_doc = 
        function.doc
        |> String.split("\n")
        |> Enum.map(&String.trim/1)
        |> Enum.join(" ")
        |> String.trim()
      
      IO.puts("  #{clean_doc}")
    else
      IO.puts("  (No documentation available)")
    end
  end
  
  defp display_function_brief(function) do
    args_str = Enum.join(function.args, ", ")
    doc_preview = 
      if function.doc do
        function.doc
        |> String.split("\n")
        |> List.first()
        |> String.trim()
        |> case do
          long when byte_size(long) > 60 -> String.slice(long, 0, 57) <> "..."
          short -> short
        end
      else
        "No documentation"
      end
    
    IO.puts("  #{function.name}(#{args_str}) - #{doc_preview}")
  end
  
  defp suggest_modules(query) do
    available = RataDocs.Storage.list_modules()
    
    if length(available) > 0 do
      IO.puts("\nAvailable modules:")
      Enum.each(available, &IO.puts("  #{&1}"))
      
      # Simple fuzzy matching suggestion
      suggestions = 
        available
        |> Enum.filter(fn module ->
          String.jaro_distance(String.downcase(module), String.downcase(query)) > 0.6
        end)
        |> Enum.take(3)
      
      if length(suggestions) > 0 do
        IO.puts("\nDid you mean:")
        Enum.each(suggestions, &IO.puts("  #{&1}"))
      end
    else
      IO.puts("\nNo modules found. Run 'rata docs extract' first to load documentation.")
    end
  end
end