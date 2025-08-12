#!/usr/bin/env elixir

# Simple documentation builder that works without dependencies
defmodule SimpleDocs do
  def build do
    IO.puts("Building Rata documentation...")
    
    # Try to extract from existing manual files
    manual_dir = "../manual"
    
    if File.exists?(manual_dir) do
      IO.puts("Found existing manual documentation in #{manual_dir}")
      list_manual_files(manual_dir)
    else
      IO.puts("No manual directory found")
    end
    
    # Check for any .rata files with docs
    check_rata_files()
    
    IO.puts("Documentation build completed!")
  end
  
  defp list_manual_files(dir) do
    case File.ls(dir) do
      {:ok, files} ->
        IO.puts("Manual files found:")
        files
        |> Enum.filter(&(String.ends_with?(&1, ".md")))
        |> Enum.each(&IO.puts("  - #{&1}"))
      {:error, reason} ->
        IO.puts("Error reading manual directory: #{reason}")
    end
  end
  
  defp check_rata_files do
    rata_files = find_rata_files(["../specs/samples", "../examples", "../src", "."])
    
    if length(rata_files) > 0 do
      IO.puts("Found #{length(rata_files)} .rata files:")
      Enum.each(rata_files, &IO.puts("  - #{&1}"))
    else
      IO.puts("No .rata files found")
    end
  end
  
  defp find_rata_files(dirs) do
    dirs
    |> Enum.flat_map(fn dir ->
      case File.ls(dir) do
        {:ok, files} ->
          files
          |> Enum.filter(&String.ends_with?(&1, ".rata"))
          |> Enum.map(&Path.join(dir, &1))
        {:error, _} -> []
      end
    end)
  end
end

SimpleDocs.build()