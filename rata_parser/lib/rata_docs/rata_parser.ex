defmodule RataDocs.RataParser do
  @moduledoc """
  Parses Rata source files to extract documentation information.
  
  This module uses the existing Rata parser to analyze .rata files
  and extract module and function documentation from docstrings.
  """
  
  alias RataParser.AST
  
  @doc """
  Extract documentation from a Rata source file.
  """
  def extract_from_file(file_path) do
    with {:ok, content} <- File.read(file_path),
         {:ok, ast} <- RataParser.parse(content),
         {:ok, docs} <- extract_from_ast(ast, file_path) do
      {:ok, docs}
    else
      {:error, reason} -> {:error, "Failed to parse #{file_path}: #{reason}"}
    end
  end
  
  @doc """
  Extract documentation from parsed AST.
  """
  def extract_from_ast(%AST.Module{} = module_ast, file_path \\ nil) do
    module_doc = extract_module_doc(module_ast)
    functions = extract_functions(module_ast.body)
    
    doc = %{
      name: module_ast.name,
      file: file_path,
      module_doc: module_doc,
      functions: functions
    }
    
    {:ok, doc}
  end
  
  def extract_from_ast(_, _file_path) do
    {:error, "AST is not a module"}
  end
  
  defp extract_module_doc(%AST.Module{docstring: nil}), do: nil
  defp extract_module_doc(%AST.Module{docstring: %AST.Docstring{content: content}}) do
    clean_docstring(content)
  end
  
  defp extract_functions(body) when is_list(body) do
    body
    |> Enum.filter(&is_function_def?/1)
    |> Enum.map(&extract_function_doc/1)
    |> Enum.reject(&is_nil/1)
  end
  
  defp is_function_def?(%AST.FunctionDef{}), do: true
  defp is_function_def?(%AST.Assignment{value: %AST.Function{}}), do: true
  defp is_function_def?(_), do: false
  
  defp extract_function_doc(%AST.FunctionDef{} = func_def) do
    %{
      name: func_def.name,
      signature: build_signature(func_def.name, func_def.params),
      arity: length(func_def.params || []),
      doc: extract_function_docstring(func_def.docstring),
      args: extract_param_names(func_def.params)
    }
  end
  
  defp extract_function_doc(%AST.Assignment{name: name, value: %AST.Function{} = func}) do
    %{
      name: name,
      signature: build_signature(name, func.params),
      arity: length(func.params || []),
      doc: nil, # Anonymous functions assigned to variables don't have docstrings in current AST
      args: extract_param_names(func.params)
    }
  end
  
  defp extract_function_doc(_), do: nil
  
  defp extract_function_docstring(nil), do: nil
  defp extract_function_docstring(%AST.Docstring{content: content}) do
    clean_docstring(content)
  end
  
  defp build_signature(name, params) do
    arity = if params, do: length(params), else: 0
    "#{name}/#{arity}"
  end
  
  defp extract_param_names(nil), do: []
  defp extract_param_names(params) when is_list(params) do
    Enum.map(params, fn
      %AST.Parameter{name: name} -> name
      name when is_binary(name) -> name
      _ -> "arg"
    end)
  end
  
  defp clean_docstring(content) when is_binary(content) do
    content
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join(" ")
    |> String.trim()
  end
  
  defp clean_docstring(_), do: nil
end