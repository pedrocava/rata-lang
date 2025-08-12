defmodule RataDocs.Storage do
  @moduledoc """
  Handles storage and retrieval of extracted documentation data.
  
  This module manages the in-memory storage of documentation extracted
  from various sources and provides query capabilities.
  """
  
  use Agent
  
  @doc """
  Start the documentation storage agent.
  """
  def start_link(_opts \\ []) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end
  
  @doc """
  Store documentation for multiple modules.
  """
  def store_docs(docs) when is_list(docs) do
    Enum.each(docs, &store_module/1)
  end
  
  @doc """
  Store documentation for a single module.
  """
  def store_module(module_doc) do
    ensure_started()
    Agent.update(__MODULE__, fn docs ->
      Map.put(docs, module_doc.name, module_doc)
    end)
  end
  
  @doc """
  Get documentation for a specific module.
  """
  def get_module(module_name) do
    ensure_started()
    Agent.get(__MODULE__, fn docs ->
      Map.get(docs, module_name)
    end)
  end
  
  @doc """
  List all modules with documentation.
  """
  def list_modules do
    ensure_started()
    Agent.get(__MODULE__, fn docs ->
      Map.keys(docs) |> Enum.sort()
    end)
  end
  
  @doc """
  Search for functions across all modules.
  """
  def search_functions(query) do
    ensure_started()
    Agent.get(__MODULE__, fn docs ->
      docs
      |> Enum.flat_map(fn {module_name, module_doc} ->
        module_doc.functions
        |> Enum.filter(fn function ->
          String.contains?(String.downcase(function.name), String.downcase(query)) or
          (function.doc && String.contains?(String.downcase(function.doc), String.downcase(query)))
        end)
        |> Enum.map(fn function ->
          Map.put(function, :module, module_name)
        end)
      end)
    end)
  end
  
  @doc """
  Get all stored documentation.
  """
  def get_all_docs do
    ensure_started()
    Agent.get(__MODULE__, & &1)
  end
  
  @doc """
  Clear all stored documentation.
  """
  def clear do
    ensure_started()
    Agent.update(__MODULE__, fn _ -> %{} end)
  end
  
  defp ensure_started do
    case Process.whereis(__MODULE__) do
      nil -> start_link()
      _ -> :ok
    end
  end
end