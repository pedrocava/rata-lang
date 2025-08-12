defmodule RataDocs.Extractor do
  @moduledoc """
  Extracts documentation from Elixir module implementations.
  
  This module parses @moduledoc and @doc attributes from Elixir modules
  in the rata_modules directory and converts them into structured data
  for documentation generation.
  """
  
  @modules_path "lib/rata_modules"
  
  @doc """
  Extract documentation from all Rata modules.
  """
  def extract_all do
    with {:ok, modules} <- find_module_files(),
         {:ok, docs} <- extract_from_modules(modules) do
      RataDocs.Storage.store_docs(docs)
      IO.puts("Extracted documentation from #{length(docs)} modules")
      :ok
    else
      {:error, reason} -> {:error, reason}
    end
  end
  
  @doc """
  Extract documentation from a specific module file.
  """
  def extract_from_file(file_path) do
    with {:ok, content} <- File.read(file_path),
         {:ok, ast} <- Code.string_to_quoted(content),
         {:ok, docs} <- extract_from_ast(ast, file_path) do
      {:ok, docs}
    else
      {:error, reason} -> {:error, "Failed to extract from #{file_path}: #{reason}"}
    end
  end
  
  defp find_module_files do
    case File.ls(@modules_path) do
      {:ok, files} ->
        elixir_files = 
          files
          |> Enum.filter(&String.ends_with?(&1, ".ex"))
          |> Enum.map(&Path.join(@modules_path, &1))
        {:ok, elixir_files}
      {:error, reason} -> 
        {:error, "Cannot read modules directory: #{reason}"}
    end
  end
  
  defp extract_from_modules(module_files) do
    results = 
      module_files
      |> Enum.map(&extract_from_file/1)
      |> Enum.reduce({[], []}, fn
        {:ok, doc}, {docs, errors} -> {[doc | docs], errors}
        {:error, err}, {docs, errors} -> {docs, [err | errors]}
      end)
    
    case results do
      {docs, []} -> {:ok, Enum.reverse(docs)}
      {_docs, errors} -> {:error, "Extraction errors: #{Enum.join(errors, ", ")}"}
    end
  end
  
  defp extract_from_ast(ast, file_path) do
    case ast do
      {:defmodule, _, [module_alias, [do: body]]} ->
        module_name = extract_module_name(module_alias)
        
        {module_doc, functions} = extract_module_contents(body)
        
        doc = %{
          name: module_name,
          file: file_path,
          module_doc: module_doc,
          functions: functions
        }
        
        {:ok, doc}
      
      _ -> 
        {:error, "Invalid module structure"}
    end
  end
  
  defp extract_module_name({:__aliases__, _, parts}) do
    parts
    |> Enum.map(&Atom.to_string/1)
    |> Enum.drop_while(&(&1 == "RataModules"))
    |> Enum.join(".")
  end
  
  defp extract_module_contents({:__block__, _, statements}) do
    extract_module_contents(statements)
  end
  
  defp extract_module_contents(statements) when is_list(statements) do
    {module_doc, functions} = 
      statements
      |> Enum.reduce({nil, []}, &process_statement/2)
    
    {module_doc, Enum.reverse(functions)}
  end
  
  defp extract_module_contents(single_statement) do
    extract_module_contents([single_statement])
  end
  
  defp process_statement({:@, _, [{:moduledoc, _, [doc]}]}, {_, functions}) do
    {doc, functions}
  end
  
  defp process_statement({:@, _, [{:doc, _, [doc]}]}, {module_doc, functions}) do
    {module_doc, [{:pending_doc, doc} | functions]}
  end
  
  defp process_statement({:def, _, [{fun_name, _, args} | _]} = def_ast, {module_doc, functions}) do
    arity = if args, do: length(args), else: 0
    signature = "#{fun_name}/#{arity}"
    
    case functions do
      [{:pending_doc, doc} | rest] ->
        function_doc = %{
          name: Atom.to_string(fun_name),
          signature: signature,
          arity: arity,
          doc: doc,
          args: extract_arg_info(args)
        }
        {module_doc, [function_doc | rest]}
      
      _ ->
        function_doc = %{
          name: Atom.to_string(fun_name),
          signature: signature,
          arity: arity,
          doc: nil,
          args: extract_arg_info(args)
        }
        {module_doc, [function_doc | functions]}
    end
  end
  
  defp process_statement(_, acc), do: acc
  
  defp extract_arg_info(nil), do: []
  defp extract_arg_info(args) when is_list(args) do
    args
    |> Enum.map(fn
      {arg_name, _, _} when is_atom(arg_name) -> Atom.to_string(arg_name)
      _ -> "arg"
    end)
  end
  defp extract_arg_info(_), do: []
end