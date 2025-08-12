defmodule RataDocs do
  @moduledoc """
  Main module for Rata documentation generation and management.
  
  This module coordinates the extraction of docstrings from Elixir modules,
  parsing of Rata source files, and generation of documentation in various formats.
  """
  
  @doc """
  Extract all documentation from available sources and generate output.
  This is a convenience function that runs the full pipeline.
  """
  def build_all(format \\ :both) do
    with :ok <- extract_all_sources(),
         :ok <- RataDocs.Generator.generate_all(format) do
      IO.puts("Documentation build complete!")
      :ok
    else
      {:error, reason} ->
        IO.puts("Documentation build failed: #{reason}")
        {:error, reason}
    end
  end
  
  @doc """
  Extract documentation from all available sources.
  """
  def extract_all_sources do
    # Start the storage agent
    RataDocs.Storage.start_link()
    
    # Extract from Elixir modules
    elixir_result = RataDocs.Extractor.extract_all()
    
    # Extract from Rata source files (if any exist)
    rata_result = extract_rata_sources()
    
    case {elixir_result, rata_result} do
      {:ok, :ok} -> :ok
      {:ok, {:error, _}} -> :ok  # Continue if only Rata extraction fails
      {{:error, reason}, _} -> {:error, reason}
    end
  end
  
  defp extract_rata_sources do
    # Look for .rata files in specs/samples and other locations
    rata_files = find_rata_files()
    
    if length(rata_files) > 0 do
      IO.puts("Found #{length(rata_files)} Rata source files")
      extract_from_rata_files(rata_files)
    else
      :ok
    end
  end
  
  defp find_rata_files do
    ["specs/samples", "examples", "src"]
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
  
  defp extract_from_rata_files(files) do
    results = 
      files
      |> Enum.map(&RataDocs.RataParser.extract_from_file/1)
      |> Enum.reduce({[], []}, fn
        {:ok, doc}, {docs, errors} -> {[doc | docs], errors}
        {:error, err}, {docs, errors} -> {docs, [err | errors]}
      end)
    
    case results do
      {docs, []} when length(docs) > 0 ->
        RataDocs.Storage.store_docs(docs)
        IO.puts("Extracted documentation from #{length(docs)} Rata modules")
        :ok
      {[], []} -> 
        :ok
      {_docs, errors} -> 
        IO.puts("Some Rata files had extraction errors: #{Enum.join(errors, ", ")}")
        :ok  # Don't fail the whole process
    end
  end
  
  @doc """
  Get the list of available modules with documentation.
  """
  def list_modules do
    RataDocs.Storage.list_modules()
  end
  
  @doc """
  Get documentation for a specific module.
  """
  def get_module_docs(module_name) do
    RataDocs.Storage.get_module(module_name)
  end
end