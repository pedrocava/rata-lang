defmodule RataModules.Json do
  @moduledoc """
  JSON toolkit for the Rata programming language.
  
  Provides JSON parsing, encoding, and validation following Rata's design principles:
  - All values are vectors (no scalars)
  - Functions with `!` suffix return wrapped results: {:ok, result} or {:error, message}
  - Functions without `!` suffix return unwrapped results or raise exceptions
  - Immutable by default
  - Data-first philosophy
  - Vectorized operations (accepts lists where applicable)
  
  This module handles JSON operations for data engineering workflows, converting between
  Rata data structures (Maps, Lists, Vectors) and JSON strings.
  
  ## Function Convention
  
  Each operation comes in two variants:
  - `function_name/arity` - Returns direct results, raises exceptions on errors
  - `function_name!/arity` - Returns `{:ok, result}` or `{:error, reason}` tuples
  
  Functions ending in `?` also have an `is_` prefixed alias:
  - `valid?/1` and `is_valid/1` - Check if string is valid JSON
  - `valid?!/1` and `is_valid!/1` - Wrapped versions
  
  ## Examples
  
      # Parse JSON string
      data = Json.parse(~s|{"name": "Alice", "age": 30}|)
      # => %{"name" => "Alice", "age" => 30}
      
      # Encode data to JSON
      json = Json.encode(%{"name" => "Bob", "items" => [1, 2, 3]})
      # => ~s|{"name":"Bob","items":[1,2,3]}|
      
      # Validate JSON
      Json.valid?(~s|{"valid": true}|)  # => true
      Json.is_valid(~s|{invalid}|)       # => false
      
      # Wrapped versions for error handling
      case Json.parse!(json_string) do
        {:ok, data} -> process_data(data)
        {:error, message} -> Log.error("JSON parse failed: #{message}")
      end
  """

  @doc """
  Parse a JSON string to Rata data structures (unwrapped version - raises on error).
  
  Converts JSON objects to Maps, JSON arrays to Lists, and preserves JSON primitives.
  
  ## Examples
  
      iex> Json.parse(~s|{"name": "Alice", "age": 30}|)
      %{"name" => "Alice", "age" => 30}
      
      iex> Json.parse(~s|[1, 2, 3]|)
      [1, 2, 3]
      
      iex> Json.parse(~s|["json1", "json2"]|)
      ["json1", "json2"]
  """
  def parse(json_string) when is_binary(json_string) do
    case Jason.decode(json_string) do
      {:ok, data} -> data
      {:error, %Jason.DecodeError{data: data, position: pos}} ->
        raise "Failed to parse JSON: invalid syntax at position #{pos} in '#{String.slice(data, 0, 50)}...'"
      {:error, reason} ->
        raise "Failed to parse JSON: #{inspect(reason)}"
    end
  end

  def parse(json_strings) when is_list(json_strings) do
    Enum.map(json_strings, &parse/1)
  end

  def parse(invalid) do
    raise "Json.parse requires a string or list of strings, got #{inspect(invalid)}"
  end

  @doc """
  Parse a JSON string to Rata data structures (wrapped version - returns {:ok, result} or {:error, reason}).
  
  ## Examples
  
      iex> Json.parse!(~s|{"name": "Alice"}|)
      {:ok, %{"name" => "Alice"}}
      
      iex> Json.parse!(~s|{invalid}|)
      {:error, "Failed to parse JSON: invalid syntax at position 1"}
  """
  def parse!(json_string) when is_binary(json_string) do
    case Jason.decode(json_string) do
      {:ok, data} -> {:ok, data}
      {:error, %Jason.DecodeError{data: data, position: pos}} ->
        {:error, "Failed to parse JSON: invalid syntax at position #{pos} in '#{String.slice(data, 0, 50)}...'"}
      {:error, reason} ->
        {:error, "Failed to parse JSON: #{inspect(reason)}"}
    end
  end

  def parse!(json_strings) when is_list(json_strings) do
    results = Enum.map(json_strings, &parse!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        data_list = Enum.map(results, fn {:ok, data} -> data end)
        {:ok, data_list}
      error -> error
    end
  end

  def parse!(invalid) do
    {:error, "Json.parse! requires a string or list of strings, got #{inspect(invalid)}"}
  end

  @doc """
  Parse JSON from a file (unwrapped version - raises on error).
  
  Reads the file and parses its JSON contents to Rata data structures.
  
  ## Examples
  
      iex> Json.parse_file("/path/to/data.json")
      %{"users" => [%{"name" => "Alice"}, %{"name" => "Bob"}]}
      
      iex> Json.parse_file(["/file1.json", "/file2.json"])
      [%{"data1" => "value1"}, %{"data2" => "value2"}]
  """
  def parse_file(file_path) when is_binary(file_path) do
    case File.read(file_path) do
      {:ok, content} -> parse(content)
      {:error, reason} -> raise "Failed to read file #{file_path}: #{reason}"
    end
  end

  def parse_file(file_paths) when is_list(file_paths) do
    Enum.map(file_paths, &parse_file/1)
  end

  def parse_file(invalid) do
    raise "Json.parse_file requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Parse JSON from a file (wrapped version - returns {:ok, result} or {:error, reason}).
  
  ## Examples
  
      iex> Json.parse_file!("/path/to/data.json")
      {:ok, %{"users" => [%{"name" => "Alice"}]}}
      
      iex> Json.parse_file!("/nonexistent.json")
      {:error, "Failed to read file /nonexistent.json: enoent"}
  """
  def parse_file!(file_path) when is_binary(file_path) do
    case File.read(file_path) do
      {:ok, content} -> parse!(content)
      {:error, reason} -> {:error, "Failed to read file #{file_path}: #{reason}"}
    end
  end

  def parse_file!(file_paths) when is_list(file_paths) do
    results = Enum.map(file_paths, &parse_file!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        data_list = Enum.map(results, fn {:ok, data} -> data end)
        {:ok, data_list}
      error -> error
    end
  end

  def parse_file!(invalid) do
    {:error, "Json.parse_file! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Encode Rata data to JSON string (unwrapped version - raises on error).
  
  Converts Rata Maps to JSON objects, Lists to JSON arrays, and preserves primitives.
  Uses compact formatting without indentation.
  
  ## Examples
  
      iex> Json.encode(%{"name" => "Alice", "age" => 30})
      ~s|{"name":"Alice","age":30}|
      
      iex> Json.encode([1, 2, 3])
      "[1,2,3]"
      
      iex> Json.encode([%{"a" => 1}, %{"b" => 2}])
      [~s|{"a":1}|, ~s|{"b":2}|]
  """
  def encode(data) when is_map(data) or is_list(data) or is_binary(data) or is_number(data) or is_boolean(data) or is_nil(data) do
    case Jason.encode(data) do
      {:ok, json_string} -> json_string
      {:error, %Jason.EncodeError{message: message}} ->
        raise "Failed to encode to JSON: #{message}"
      {:error, reason} ->
        raise "Failed to encode to JSON: #{inspect(reason)}"
    end
  end

  def encode(data_list) when is_list(data_list) do
    Enum.map(data_list, &encode/1)
  end

  def encode(invalid) do
    raise "Json.encode requires encodable data (Map, List, String, Number, Boolean, nil), got #{inspect(invalid)}"
  end

  @doc """
  Encode Rata data to JSON string (wrapped version - returns {:ok, result} or {:error, reason}).
  
  ## Examples
  
      iex> Json.encode!(%{"name" => "Alice"})
      {:ok, ~s|{"name":"Alice"}|}
      
      iex> Json.encode!(:invalid_atom)
      {:error, "Failed to encode to JSON: cannot encode atom"}
  """
  def encode!(data) when is_map(data) or is_list(data) or is_binary(data) or is_number(data) or is_boolean(data) or is_nil(data) do
    case Jason.encode(data) do
      {:ok, json_string} -> {:ok, json_string}
      {:error, %Jason.EncodeError{message: message}} ->
        {:error, "Failed to encode to JSON: #{message}"}
      {:error, reason} ->
        {:error, "Failed to encode to JSON: #{inspect(reason)}"}
    end
  end

  def encode!(data_list) when is_list(data_list) do
    results = Enum.map(data_list, &encode!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        json_list = Enum.map(results, fn {:ok, json} -> json end)
        {:ok, json_list}
      error -> error
    end
  end

  def encode!(invalid) do
    {:error, "Json.encode! requires encodable data (Map, List, String, Number, Boolean, nil), got #{inspect(invalid)}"}
  end

  @doc """
  Encode Rata data to pretty-formatted JSON string (unwrapped version - raises on error).
  
  Same as encode/1 but with indentation and line breaks for readability.
  
  ## Examples
  
      iex> Json.encode_pretty(%{"name" => "Alice", "age" => 30})
      ~s|{
        "name": "Alice",
        "age": 30
      }|
  """
  def encode_pretty(data) when is_map(data) or is_list(data) or is_binary(data) or is_number(data) or is_boolean(data) or is_nil(data) do
    case Jason.encode(data, pretty: true) do
      {:ok, json_string} -> json_string
      {:error, %Jason.EncodeError{message: message}} ->
        raise "Failed to encode to pretty JSON: #{message}"
      {:error, reason} ->
        raise "Failed to encode to pretty JSON: #{inspect(reason)}"
    end
  end

  def encode_pretty(data_list) when is_list(data_list) do
    Enum.map(data_list, &encode_pretty/1)
  end

  def encode_pretty(invalid) do
    raise "Json.encode_pretty requires encodable data (Map, List, String, Number, Boolean, nil), got #{inspect(invalid)}"
  end

  @doc """
  Encode Rata data to pretty-formatted JSON string (wrapped version - returns {:ok, result} or {:error, reason}).
  
  ## Examples
  
      iex> Json.encode_pretty!(%{"name" => "Alice"})
      {:ok, ~s|{\n  "name": "Alice"\n}|}
  """
  def encode_pretty!(data) when is_map(data) or is_list(data) or is_binary(data) or is_number(data) or is_boolean(data) or is_nil(data) do
    case Jason.encode(data, pretty: true) do
      {:ok, json_string} -> {:ok, json_string}
      {:error, %Jason.EncodeError{message: message}} ->
        {:error, "Failed to encode to pretty JSON: #{message}"}
      {:error, reason} ->
        {:error, "Failed to encode to pretty JSON: #{inspect(reason)}"}
    end
  end

  def encode_pretty!(data_list) when is_list(data_list) do
    results = Enum.map(data_list, &encode_pretty!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        json_list = Enum.map(results, fn {:ok, json} -> json end)
        {:ok, json_list}
      error -> error
    end
  end

  def encode_pretty!(invalid) do
    {:error, "Json.encode_pretty! requires encodable data (Map, List, String, Number, Boolean, nil), got #{inspect(invalid)}"}
  end

  @doc """
  Write JSON data to a file (unwrapped version - raises on error).
  
  Encodes the data to JSON and writes it to the specified file path.
  
  ## Examples
  
      iex> Json.write_file(%{"users" => ["Alice", "Bob"]}, "/path/to/output.json")
      "/path/to/output.json"
  """
  def write_file(data, file_path) when is_binary(file_path) do
    json_string = encode(data)
    case File.write(file_path, json_string) do
      :ok -> file_path
      {:error, reason} -> raise "Failed to write JSON to file #{file_path}: #{reason}"
    end
  end

  def write_file(data, file_path) do
    raise "Json.write_file requires data and a string file path, got #{inspect(data)} and #{inspect(file_path)}"
  end

  @doc """
  Write JSON data to a file (wrapped version - returns {:ok, result} or {:error, reason}).
  
  ## Examples
  
      iex> Json.write_file!(%{"data" => "value"}, "/path/to/output.json")
      {:ok, "/path/to/output.json"}
      
      iex> Json.write_file!(%{"data" => "value"}, "/invalid/path/file.json")
      {:error, "Failed to write JSON to file /invalid/path/file.json: enoent"}
  """
  def write_file!(data, file_path) when is_binary(file_path) do
    case encode!(data) do
      {:ok, json_string} ->
        case File.write(file_path, json_string) do
          :ok -> {:ok, file_path}
          {:error, reason} -> {:error, "Failed to write JSON to file #{file_path}: #{reason}"}
        end
      error -> error
    end
  end

  def write_file!(data, file_path) do
    {:error, "Json.write_file! requires data and a string file path, got #{inspect(data)} and #{inspect(file_path)}"}
  end

  @doc """
  Check if a string contains valid JSON (unwrapped version - raises on error).
  
  Returns true if the string can be parsed as valid JSON, false otherwise.
  
  ## Examples
  
      iex> Json.valid?(~s|{"name": "Alice"}|)
      true
      
      iex> Json.valid?(~s|{invalid json}|)
      false
      
      iex> Json.valid?([~s|{"valid": true}|, ~s|{invalid}|])
      [true, false]
  """
  def valid?(json_string) when is_binary(json_string) do
    case Jason.decode(json_string) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  def valid?(json_strings) when is_list(json_strings) do
    Enum.map(json_strings, &valid?/1)
  end

  def valid?(invalid) do
    raise "Json.valid? requires a string or list of strings, got #{inspect(invalid)}"
  end

  @doc """
  Alias for valid?/1 - Check if a string contains valid JSON.
  
  ## Examples
  
      iex> Json.is_valid(~s|{"name": "Alice"}|)
      true
      
      iex> Json.is_valid(~s|{invalid json}|)
      false
  """
  def is_valid(json_string_or_list) do
    valid?(json_string_or_list)
  end

  @doc """
  Check if a string contains valid JSON (wrapped version - returns {:ok, result} or {:error, reason}).
  
  ## Examples
  
      iex> Json.valid?!(~s|{"name": "Alice"}|)
      {:ok, true}
      
      iex> Json.valid?!(~s|{invalid json}|)
      {:ok, false}
      
      iex> Json.valid?!([~s|{"valid": true}|, ~s|{invalid}|])
      {:ok, [true, false]}
  """
  def valid?!(json_string) when is_binary(json_string) do
    result = case Jason.decode(json_string) do
      {:ok, _} -> true
      {:error, _} -> false
    end
    {:ok, result}
  end

  def valid?!(json_strings) when is_list(json_strings) do
    results = Enum.map(json_strings, fn json_string ->
      case Jason.decode(json_string) do
        {:ok, _} -> true
        {:error, _} -> false
      end
    end)
    {:ok, results}
  end

  def valid?!(invalid) do
    {:error, "Json.valid?! requires a string or list of strings, got #{inspect(invalid)}"}
  end

  @doc """
  Alias for valid?!/1 - Check if a string contains valid JSON (wrapped version).
  
  ## Examples
  
      iex> Json.is_valid!(~s|{"name": "Alice"}|)
      {:ok, true}
  """
  def is_valid!(json_string_or_list) do
    valid?!(json_string_or_list)
  end
end