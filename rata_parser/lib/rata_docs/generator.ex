defmodule RataDocs.Generator do
  @moduledoc """
  Generates documentation in various formats from extracted docstrings.
  
  This module can output documentation as Markdown files and generate 
  PDF documentation using Typst templates.
  """
  
  @output_dir "docs/generated"
  @templates_dir "lib/rata_docs/templates"
  
  @doc """
  Generate documentation for all modules in the specified format.
  """
  def generate_all(format \\ :both) do
    docs = RataDocs.Storage.get_all_docs()
    
    if map_size(docs) == 0 do
      {:error, "No documentation found. Run 'rata docs extract' first."}
    else
      ensure_output_directory()
      
      case format do
        :markdown -> generate_markdown_docs(docs)
        :typst -> generate_typst_docs(docs) 
        :both -> 
          with :ok <- generate_markdown_docs(docs),
               :ok <- generate_typst_docs(docs) do
            :ok
          end
        _ -> {:error, "Unknown format: #{format}"}
      end
    end
  end
  
  @doc """
  Generate documentation for a specific module.
  """
  def generate_module(module_name, format \\ :both) do
    case RataDocs.Storage.get_module(module_name) do
      nil -> 
        {:error, "Module '#{module_name}' not found"}
      
      module_doc ->
        ensure_output_directory()
        
        case format do
          :markdown -> generate_markdown_module(module_doc)
          :typst -> generate_typst_module(module_doc)
          :both ->
            with :ok <- generate_markdown_module(module_doc),
                 :ok <- generate_typst_module(module_doc) do
              :ok
            end
        end
    end
  end
  
  defp generate_markdown_docs(docs) do
    modules = Map.values(docs) |> Enum.sort_by(& &1.name)
    
    # Generate individual module files
    results = Enum.map(modules, &generate_markdown_module/1)
    
    # Generate index file
    index_result = generate_markdown_index(modules)
    
    case Enum.find([index_result | results], &match?({:error, _}, &1)) do
      nil -> 
        IO.puts("Generated Markdown documentation for #{length(modules)} modules")
        :ok
      {:error, reason} -> 
        {:error, reason}
    end
  end
  
  defp generate_markdown_module(module_doc) do
    content = build_markdown_content(module_doc)
    filename = "#{String.downcase(module_doc.name)}.md"
    output_path = Path.join(@output_dir, filename)
    
    case File.write(output_path, content) do
      :ok -> :ok
      {:error, reason} -> {:error, "Failed to write #{filename}: #{reason}"}
    end
  end
  
  defp generate_markdown_index(modules) do
    content = build_markdown_index(modules)
    output_path = Path.join(@output_dir, "index.md")
    
    case File.write(output_path, content) do
      :ok -> :ok
      {:error, reason} -> {:error, "Failed to write index.md: #{reason}"}
    end
  end
  
  defp generate_typst_docs(docs) do
    modules = Map.values(docs) |> Enum.sort_by(& &1.name)
    
    # Generate combined documentation
    with :ok <- generate_typst_combined(modules),
         :ok <- compile_typst_to_pdf("all_modules") do
      IO.puts("Generated Typst documentation for #{length(modules)} modules")
      :ok
    end
  end
  
  defp generate_typst_module(module_doc) do
    with :ok <- generate_typst_single_module(module_doc),
         :ok <- compile_typst_to_pdf(String.downcase(module_doc.name)) do
      :ok
    end
  end
  
  defp generate_typst_combined(modules) do
    # Create the data file for Typst
    typst_data = build_typst_data(modules)
    
    content = """
    #import "#{@templates_dir}/all_modules.typ": all_modules_doc
    
    #{typst_data}
    
    #all_modules_doc(modules: modules_data)
    """
    
    output_path = Path.join(@output_dir, "all_modules.typ")
    
    case File.write(output_path, content) do
      :ok -> :ok
      {:error, reason} -> {:error, "Failed to write all_modules.typ: #{reason}"}
    end
  end
  
  defp generate_typst_single_module(module_doc) do
    typst_data = build_typst_module_data(module_doc)
    
    content = """
    #import "#{@templates_dir}/module.typ": module_doc
    
    #{typst_data}
    
    #module_doc(
      name: module_name,
      description: module_description,
      functions: module_functions,
    )
    """
    
    filename = "#{String.downcase(module_doc.name)}.typ"
    output_path = Path.join(@output_dir, filename)
    
    case File.write(output_path, content) do
      :ok -> :ok
      {:error, reason} -> {:error, "Failed to write #{filename}: #{reason}"}
    end
  end
  
  defp compile_typst_to_pdf(basename) do
    input_file = Path.join(@output_dir, "#{basename}.typ")
    output_file = Path.join(@output_dir, "#{basename}.pdf")
    
    case System.cmd("typst", ["compile", input_file, output_file], stderr_to_stdout: true) do
      {_output, 0} -> 
        :ok
      {error_output, _} -> 
        IO.puts("Typst compilation warning/error: #{error_output}")
        # Don't fail on Typst errors, just warn
        :ok
    end
  rescue
    System.ErlangError ->
      IO.puts("Typst not found. Install Typst to generate PDF documentation.")
      :ok
  end
  
  defp build_markdown_content(module_doc) do
    """
    # #{module_doc.name} Module
    
    #{if module_doc.module_doc, do: module_doc.module_doc, else: ""}
    
    ## Import
    
    ```rata
    library #{module_doc.name}
    ```
    
    ## Functions
    
    #{build_markdown_functions(module_doc.functions)}
    """
  end
  
  defp build_markdown_functions(functions) when length(functions) == 0 do
    "_No functions documented._"
  end
  
  defp build_markdown_functions(functions) do
    functions
    |> Enum.sort_by(& &1.name)
    |> Enum.map(&build_markdown_function/1)
    |> Enum.join("\n\n")
  end
  
  defp build_markdown_function(function) do
    args_str = Enum.join(function.args, ", ")
    doc_str = if function.doc, do: function.doc, else: "_No documentation available._"
    
    """
    ### `#{function.name}(#{args_str})`
    
    #{doc_str}
    """
  end
  
  defp build_markdown_index(modules) do
    module_links = 
      modules
      |> Enum.map(fn module ->
        filename = String.downcase(module.name) <> ".md"
        "- [#{module.name}](#{filename})"
      end)
      |> Enum.join("\n")
    
    """
    # Rata Standard Library
    
    Generated documentation from source code docstrings.
    
    ## Modules
    
    #{module_links}
    """
  end
  
  defp build_typst_data(modules) do
    modules_data = 
      modules
      |> Enum.map(&build_typst_module_data_struct/1)
      |> Enum.join(",\n  ")
    
    "#let modules_data = (\n  #{modules_data}\n)\n"
  end
  
  defp build_typst_module_data(module_doc) do
    struct_data = build_typst_module_data_struct(module_doc)
    
    "#let module_name = \"#{module_doc.name}\"\n" <>
    "#let module_description = \"#{escape_typst_string(module_doc.module_doc || "")}\"\n" <>
    "#let module_functions = #{build_typst_functions_array(module_doc.functions)}\n"
  end
  
  defp build_typst_module_data_struct(module_doc) do
    "(\n" <>
    "    name: \"#{module_doc.name}\",\n" <>
    "    module_doc: \"#{escape_typst_string(module_doc.module_doc || "")}\",\n" <>
    "    functions: #{build_typst_functions_array(module_doc.functions)}\n" <>
    "  )"
  end
  
  defp build_typst_functions_array(functions) do
    if length(functions) == 0 do
      "()"
    else
      func_data = 
        functions
        |> Enum.map(&build_typst_function_struct/1)
        |> Enum.join(",\n    ")
      
      "(\n  #{func_data}\n)"
    end
  end
  
  defp build_typst_function_struct(function) do
    args_array = function.args |> Enum.map(&"\"#{&1}\"") |> Enum.join(", ")
    
    "(\n" <>
    "    name: \"#{function.name}\",\n" <>
    "    args: (#{args_array}),\n" <>
    "    doc: \"#{escape_typst_string(function.doc || "")}\"\n" <>
    "  )"
  end
  
  defp escape_typst_string(nil), do: ""
  defp escape_typst_string(str) do
    str
    |> String.replace("\"", "\\\"")
    |> String.replace("\\", "\\\\")
    |> String.replace("\n", " ")
    |> String.replace("\r", "")
    |> String.trim()
  end
  
  defp ensure_output_directory do
    File.mkdir_p!(@output_dir)
  end
end