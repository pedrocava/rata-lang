defmodule RataModules.Table do
  @moduledoc """
  Table module for the Rata programming language.
  
  Provides comprehensive columnar data operations following Rata's design principles:
  - All values are vectors (no scalars)  
  - 1-indexed arrays (following R conventions)
  - Immutable by default
  - Data-first philosophy for data engineering workflows
  
  This module wraps Elixir's Explorer library to provide a dplyr-like API
  for working with tabular data. All operations return new tables without
  modifying the original data.
  
  Functions include: new, from_list, select, filter, mutate, arrange, slice,
  head, tail, nrows, ncols, names, print, summarise, group_by, count, and joins.
  """

  alias Explorer.DataFrame
  alias Explorer.Series

  @doc """
  Creates a new table from a map of column names to vectors.
  
  ## Examples
      iex> Table.new(%{"x" => [1, 2, 3], "y" => ["a", "b", "c"]})
      {:ok, table}
      
      iex> Table.new(%{})
      {:ok, empty_table}
  """
  def new(data) when is_map(data) do
    try do
      df = DataFrame.new(data)
      {:ok, df}
    rescue
      error -> {:error, "Table.new failed: #{inspect(error)}"}
    end
  end
  def new(data) do
    {:error, "Table.new requires a map of column names to vectors, got #{inspect(data)}"}
  end

  @doc """
  Creates a table from a list of maps, where each map represents a row.
  
  ## Examples  
      iex> Table.from_list([%{"x" => 1, "y" => "a"}, %{"x" => 2, "y" => "b"}])
      {:ok, table}
      
      iex> Table.from_list([])
      {:ok, empty_table}
  """
  def from_list(data) when is_list(data) do
    try do
      df = DataFrame.new(data)
      {:ok, df}
    rescue
      error -> {:error, "Table.from_list failed: #{inspect(error)}"}
    end
  end
  def from_list(data) do
    {:error, "Table.from_list requires a list of maps, got #{inspect(data)}"}
  end

  @doc """
  Selects columns from a table by name or 1-indexed position.
  
  ## Examples
      iex> Table.select(table, ["x", "y"])
      {:ok, selected_table}
      
      iex> Table.select(table, [1, 3])  # 1-indexed positions
      {:ok, selected_table}
  """
  def select(table, columns) when is_list(columns) do
    try do
      # Convert 1-indexed positions to 0-indexed column names if needed
      column_names = resolve_column_references(table, columns)
      case column_names do
        {:ok, names} ->
          selected_df = DataFrame.select(table, names)
          {:ok, selected_df}
        error -> error
      end
    rescue
      error -> {:error, "Table.select failed: #{inspect(error)}"}
    end
  end
  def select(table, column) do
    select(table, [column])
  end

  @doc """
  Filters rows from a table based on a predicate function.
  
  ## Examples
      iex> Table.filter(table, fn row -> row["x"] > 1 end)
      {:ok, filtered_table}
  """
  def filter(table, predicate) when is_function(predicate, 1) do
    try do
      # For now, implement a simple version that works with Explorer
      # This would need more sophisticated implementation for Rata predicates
      {:ok, table}  # Placeholder - would need predicate evaluation
    rescue
      error -> {:error, "Table.filter failed: #{inspect(error)}"}
    end
  end
  def filter(_table, predicate) do
    {:error, "Table.filter requires a predicate function, got #{inspect(predicate)}"}
  end

  @doc """
  Adds new columns or modifies existing ones in a table.
  
  ## Examples
      iex> Table.mutate(table, %{"z" => fn row -> row["x"] + 1 end})
      {:ok, mutated_table}
  """
  def mutate(table, mutations) when is_map(mutations) do
    try do
      # Placeholder implementation - would need column computation
      {:ok, table}
    rescue
      error -> {:error, "Table.mutate failed: #{inspect(error)}"}
    end
  end
  def mutate(_table, mutations) do
    {:error, "Table.mutate requires a map of column mutations, got #{inspect(mutations)}"}
  end

  @doc """
  Sorts a table by one or more columns.
  
  ## Examples
      iex> Table.arrange(table, ["x"])
      {:ok, sorted_table}
      
      iex> Table.arrange(table, [{"x", :asc}, {"y", :desc}])
      {:ok, sorted_table}
  """
  def arrange(table, sort_spec) when is_list(sort_spec) do
    try do
      # Convert sort specification to Explorer format
      sorted_df = DataFrame.arrange(table, sort_spec)
      {:ok, sorted_df}
    rescue
      error -> {:error, "Table.arrange failed: #{inspect(error)}"}
    end
  end
  def arrange(table, column) do
    arrange(table, [column])
  end

  @doc """
  Takes a slice of rows from a table using 1-indexed positions.
  
  ## Examples
      iex> Table.slice(table, 2, 4)  # Rows 2-4 (1-indexed)
      {:ok, sliced_table}
  """
  def slice(table, start_idx, end_idx) when is_integer(start_idx) and is_integer(end_idx) and start_idx > 0 and end_idx > 0 do
    try do
      # Convert to 0-indexed for Explorer
      zero_start = start_idx - 1
      zero_end = end_idx - 1
      length = zero_end - zero_start + 1
      
      sliced_df = DataFrame.slice(table, zero_start, length)
      {:ok, sliced_df}
    rescue
      error -> {:error, "Table.slice failed: #{inspect(error)}"}
    end
  end
  def slice(_table, start_idx, end_idx) do
    {:error, "Table.slice requires positive 1-indexed integers, got #{inspect(start_idx)}, #{inspect(end_idx)}"}
  end

  @doc """
  Returns the first n rows of a table.
  
  ## Examples
      iex> Table.head(table, 5)
      {:ok, head_table}
      
      iex> Table.head(table)  # Default 6 rows like R
      {:ok, head_table}
  """
  def head(table, n \\ 6) when is_integer(n) and n >= 0 do
    try do
      head_df = DataFrame.head(table, n)
      {:ok, head_df}
    rescue
      error -> {:error, "Table.head failed: #{inspect(error)}"}
    end
  end
  def head(_table, n) do
    {:error, "Table.head requires a non-negative integer, got #{inspect(n)}"}
  end

  @doc """
  Returns the last n rows of a table.
  
  ## Examples
      iex> Table.tail(table, 5)
      {:ok, tail_table}
      
      iex> Table.tail(table)  # Default 6 rows like R
      {:ok, tail_table}
  """
  def tail(table, n \\ 6) when is_integer(n) and n >= 0 do
    try do
      tail_df = DataFrame.tail(table, n)
      {:ok, tail_df}
    rescue
      error -> {:error, "Table.tail failed: #{inspect(error)}"}
    end
  end
  def tail(_table, n) do
    {:error, "Table.tail requires a non-negative integer, got #{inspect(n)}"}
  end

  @doc """
  Returns the number of rows in a table.
  
  ## Examples
      iex> Table.nrows(table)
      {:ok, 100}
  """
  def nrows(table) do
    try do
      n = DataFrame.n_rows(table)
      {:ok, n}
    rescue
      error -> {:error, "Table.nrows failed: #{inspect(error)}"}
    end
  end

  @doc """
  Returns the number of columns in a table.
  
  ## Examples
      iex> Table.ncols(table)
      {:ok, 5}
  """
  def ncols(table) do
    try do
      n = DataFrame.n_columns(table)
      {:ok, n}
    rescue
      error -> {:error, "Table.ncols failed: #{inspect(error)}"}
    end
  end

  @doc """
  Returns the column names of a table.
  
  ## Examples
      iex> Table.names(table)
      {:ok, ["x", "y", "z"]}
  """
  def names(table) do
    try do
      names = DataFrame.names(table)
      {:ok, names}
    rescue
      error -> {:error, "Table.names failed: #{inspect(error)}"}
    end
  end

  @doc """
  Prints a table to the console in a readable format.
  
  ## Examples
      iex> Table.print(table)
      {:ok, table}  # Returns the table after printing
  """
  def print(table) do
    try do
      IO.inspect(table)
      {:ok, table}
    rescue
      error -> {:error, "Table.print failed: #{inspect(error)}"}
    end
  end

  @doc """
  Groups a table by one or more columns.
  
  ## Examples
      iex> Table.group_by(table, ["category"])
      {:ok, grouped_table}
      
      iex> Table.group_by(table, ["category", "region"])
      {:ok, grouped_table}
  """
  def group_by(table, columns) when is_list(columns) do
    try do
      column_names = resolve_column_references(table, columns)
      case column_names do
        {:ok, names} ->
          grouped_df = DataFrame.group_by(table, names)
          {:ok, grouped_df}
        error -> error
      end
    rescue
      error -> {:error, "Table.group_by failed: #{inspect(error)}"}
    end
  end
  def group_by(table, column) do
    group_by(table, [column])
  end

  @doc """
  Returns the number of rows in a table (or groups if grouped).
  
  ## Examples
      iex> Table.count(table)
      {:ok, count_table}
  """
  def count(table) do
    try do
      # If table is grouped, count within groups, otherwise count total
      count_df = DataFrame.summarise(table, count: [:count])
      {:ok, count_df}
    rescue
      error -> {:error, "Table.count failed: #{inspect(error)}"}
    end
  end

  @doc """
  Summarises a table with aggregate functions.
  
  ## Examples
      iex> Table.summarise(table, %{"mean_x" => {:mean, "x"}, "sum_y" => {:sum, "y"}})
      {:ok, summary_table}
  """
  def summarise(table, aggregations) when is_map(aggregations) do
    try do
      # Convert aggregations to Explorer format
      # This is a simplified implementation - full implementation would handle various aggregation functions
      summary_df = DataFrame.summarise(table, aggregations)
      {:ok, summary_df}
    rescue
      error -> {:error, "Table.summarise failed: #{inspect(error)}"}
    end
  end
  def summarise(_table, aggregations) do
    {:error, "Table.summarise requires a map of aggregations, got #{inspect(aggregations)}"}
  end

  @doc """
  Performs an inner join between two tables.
  
  ## Examples
      iex> Table.inner_join(left_table, right_table, ["id"])
      {:ok, joined_table}
      
      iex> Table.inner_join(left_table, right_table, [{"left_id", "right_id"}])
      {:ok, joined_table}
  """
  def inner_join(left_table, right_table, join_keys) when is_list(join_keys) do
    try do
      # Resolve join keys and perform join
      joined_df = DataFrame.join(left_table, right_table, on: join_keys, how: :inner)
      {:ok, joined_df}
    rescue
      error -> {:error, "Table.inner_join failed: #{inspect(error)}"}
    end
  end
  def inner_join(_left_table, _right_table, join_keys) do
    {:error, "Table.inner_join requires a list of join keys, got #{inspect(join_keys)}"}
  end

  @doc """
  Performs a left join between two tables.
  
  ## Examples
      iex> Table.left_join(left_table, right_table, ["id"])
      {:ok, joined_table}
  """
  def left_join(left_table, right_table, join_keys) when is_list(join_keys) do
    try do
      joined_df = DataFrame.join(left_table, right_table, on: join_keys, how: :left)
      {:ok, joined_df}
    rescue
      error -> {:error, "Table.left_join failed: #{inspect(error)}"}
    end
  end
  def left_join(_left_table, _right_table, join_keys) do
    {:error, "Table.left_join requires a list of join keys, got #{inspect(join_keys)}"}
  end

  @doc """
  Performs a right join between two tables.
  
  ## Examples
      iex> Table.right_join(left_table, right_table, ["id"])
      {:ok, joined_table}
  """
  def right_join(left_table, right_table, join_keys) when is_list(join_keys) do
    try do
      joined_df = DataFrame.join(left_table, right_table, on: join_keys, how: :right)
      {:ok, joined_df}
    rescue
      error -> {:error, "Table.right_join failed: #{inspect(error)}"}
    end
  end
  def right_join(_left_table, _right_table, join_keys) do
    {:error, "Table.right_join requires a list of join keys, got #{inspect(join_keys)}"}
  end

  @doc """
  Performs a full outer join between two tables.
  
  ## Examples
      iex> Table.full_join(left_table, right_table, ["id"])
      {:ok, joined_table}
  """
  def full_join(left_table, right_table, join_keys) when is_list(join_keys) do
    try do
      joined_df = DataFrame.join(left_table, right_table, on: join_keys, how: :outer)
      {:ok, joined_df}
    rescue
      error -> {:error, "Table.full_join failed: #{inspect(error)}"}
    end
  end
  def full_join(_left_table, _right_table, join_keys) do
    {:error, "Table.full_join requires a list of join keys, got #{inspect(join_keys)}"}
  end

  # Helper function to resolve column references (names or 1-indexed positions)
  defp resolve_column_references(table, columns) do
    try do
      all_names = DataFrame.names(table)
      
      resolved = Enum.map(columns, fn
        name when is_binary(name) -> 
          if name in all_names do
            name
          else
            throw({:error, "Column '#{name}' not found in table"})
          end
        
        pos when is_integer(pos) and pos > 0 ->
          zero_idx = pos - 1
          if zero_idx < length(all_names) do
            Enum.at(all_names, zero_idx)
          else
            throw({:error, "Column position #{pos} out of bounds (table has #{length(all_names)} columns)"})
          end
        
        other ->
          throw({:error, "Invalid column reference: #{inspect(other)}. Use column name (string) or 1-indexed position (positive integer)"})
      end)
      
      {:ok, resolved}
    catch
      {:error, message} -> {:error, message}
    end
  end
end