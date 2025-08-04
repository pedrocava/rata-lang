defmodule RataModules.Maps do
  @moduledoc """
  Maps module for the Rata programming language.
  
  Provides operations for working with maps/dictionaries following
  Rata's design principles:
  - All values are vectors (no scalars)
  - 1-indexed arrays
  - Immutable by default
  - Data-first philosophy
  
  Maps in Rata are represented as Elixir maps with atom keys.
  Functions include: get, put, delete, has_key, keys, values, merge, size, empty, to_list, from_list.
  """

  @doc """
  Gets a value from a map by key.
  Returns the value if the key exists, otherwise returns nil.
  
  ## Examples
      iex> Maps.get({key: "value"}, :key)
      {:ok, "value"}
      
      iex> Maps.get({key: "value"}, :missing)
      {:ok, nil}
  """
  def get(map, key) when is_map(map) and is_atom(key) do
    try do
      result = Map.get(map, key)
      {:ok, result}
    rescue
      e -> {:error, "Maps.get failed: #{Exception.message(e)}"}
    end
  end
  def get(map, _key) when not is_map(map) do
    {:error, "Maps.get requires a map as first argument, got #{inspect(map)}"}
  end
  def get(_map, key) when not is_atom(key) do
    {:error, "Maps.get requires an atom key as second argument, got #{inspect(key)}"}
  end

  @doc """
  Puts a key-value pair into a map.
  Returns a new map with the key-value pair added or updated.
  
  ## Examples
      iex> Maps.put({}, :key, "value")
      {:ok, %{key: "value"}}
      
      iex> Maps.put({existing: "old"}, :existing, "new")
      {:ok, %{existing: "new"}}
  """
  def put(map, key, value) when is_map(map) and is_atom(key) do
    try do
      result = Map.put(map, key, value)
      {:ok, result}
    rescue
      e -> {:error, "Maps.put failed: #{Exception.message(e)}"}
    end
  end
  def put(map, _key, _value) when not is_map(map) do
    {:error, "Maps.put requires a map as first argument, got #{inspect(map)}"}
  end
  def put(_map, key, _value) when not is_atom(key) do
    {:error, "Maps.put requires an atom key as second argument, got #{inspect(key)}"}
  end

  @doc """
  Deletes a key from a map.
  Returns a new map with the key removed. If key doesn't exist, returns the original map.
  
  ## Examples
      iex> Maps.delete({key: "value", other: "data"}, :key)
      {:ok, %{other: "data"}}
      
      iex> Maps.delete({key: "value"}, :missing)
      {:ok, %{key: "value"}}
  """
  def delete(map, key) when is_map(map) and is_atom(key) do
    try do
      result = Map.delete(map, key)
      {:ok, result}
    rescue
      e -> {:error, "Maps.delete failed: #{Exception.message(e)}"}
    end
  end
  def delete(map, _key) when not is_map(map) do
    {:error, "Maps.delete requires a map as first argument, got #{inspect(map)}"}
  end
  def delete(_map, key) when not is_atom(key) do
    {:error, "Maps.delete requires an atom key as second argument, got #{inspect(key)}"}
  end

  @doc """
  Checks if a map has a specific key.
  Returns true if the key exists in the map, false otherwise.
  
  ## Examples
      iex> Maps.has_key({key: "value"}, :key)
      {:ok, true}
      
      iex> Maps.has_key({key: "value"}, :missing)
      {:ok, false}
  """
  def has_key(map, key) when is_map(map) and is_atom(key) do
    try do
      result = Map.has_key?(map, key)
      {:ok, result}
    rescue
      e -> {:error, "Maps.has_key failed: #{Exception.message(e)}"}
    end
  end
  def has_key(map, _key) when not is_map(map) do
    {:error, "Maps.has_key requires a map as first argument, got #{inspect(map)}"}
  end
  def has_key(_map, key) when not is_atom(key) do
    {:error, "Maps.has_key requires an atom key as second argument, got #{inspect(key)}"}
  end

  @doc """
  Gets all keys from a map.
  Returns a list of all keys in the map.
  
  ## Examples
      iex> Maps.keys({a: 1, b: 2, c: 3})
      {:ok, [:a, :b, :c]}
      
      iex> Maps.keys({})
      {:ok, []}
  """
  def keys(map) when is_map(map) do
    try do
      result = Map.keys(map)
      {:ok, result}
    rescue
      e -> {:error, "Maps.keys failed: #{Exception.message(e)}"}
    end
  end
  def keys(map) do
    {:error, "Maps.keys requires a map as argument, got #{inspect(map)}"}
  end

  @doc """
  Gets all values from a map.
  Returns a list of all values in the map.
  
  ## Examples
      iex> Maps.values({a: 1, b: 2, c: 3})
      {:ok, [1, 2, 3]}
      
      iex> Maps.values({})
      {:ok, []}
  """
  def values(map) when is_map(map) do
    try do
      result = Map.values(map)
      {:ok, result}
    rescue
      e -> {:error, "Maps.values failed: #{Exception.message(e)}"}
    end
  end
  def values(map) do
    {:error, "Maps.values requires a map as argument, got #{inspect(map)}"}
  end

  @doc """
  Merges two maps together.
  The second map's values will overwrite the first map's values for duplicate keys.
  
  ## Examples
      iex> Maps.merge({a: 1, b: 2}, {b: 3, c: 4})
      {:ok, %{a: 1, b: 3, c: 4}}
      
      iex> Maps.merge({}, {key: "value"})
      {:ok, %{key: "value"}}
  """
  def merge(map1, map2) when is_map(map1) and is_map(map2) do
    try do
      result = Map.merge(map1, map2)
      {:ok, result}
    rescue
      e -> {:error, "Maps.merge failed: #{Exception.message(e)}"}
    end
  end
  def merge(map1, map2) when not is_map(map1) do
    {:error, "Maps.merge requires maps as arguments, got #{inspect(map1)} as first argument"}
  end
  def merge(map1, map2) when not is_map(map2) do
    {:error, "Maps.merge requires maps as arguments, got #{inspect(map2)} as second argument"}
  end

  @doc """
  Gets the size of a map.
  Returns the number of key-value pairs in the map.
  
  ## Examples
      iex> Maps.size({a: 1, b: 2, c: 3})
      {:ok, 3}
      
      iex> Maps.size({})
      {:ok, 0}
  """
  def size(map) when is_map(map) do
    try do
      result = map_size(map)
      {:ok, result}
    rescue
      e -> {:error, "Maps.size failed: #{Exception.message(e)}"}
    end
  end
  def size(map) do
    {:error, "Maps.size requires a map as argument, got #{inspect(map)}"}
  end

  @doc """
  Checks if a map is empty.
  Returns true if the map has no key-value pairs, false otherwise.
  
  ## Examples
      iex> Maps.empty({})
      {:ok, true}
      
      iex> Maps.empty({key: "value"})
      {:ok, false}
  """
  def empty(map) when is_map(map) do
    try do
      result = map_size(map) == 0
      {:ok, result}
    rescue
      e -> {:error, "Maps.empty failed: #{Exception.message(e)}"}
    end
  end
  def empty(map) do
    {:error, "Maps.empty requires a map as argument, got #{inspect(map)}"}
  end

  @doc """
  Converts a map to a list of key-value tuples.
  Returns a list where each element is a two-element tuple {key, value}.
  
  ## Examples
      iex> Maps.to_list({a: 1, b: 2})
      {:ok, [{:a, 1}, {:b, 2}]}
      
      iex> Maps.to_list({})
      {:ok, []}
  """
  def to_list(map) when is_map(map) do
    try do
      result = Map.to_list(map)
      {:ok, result}
    rescue
      e -> {:error, "Maps.to_list failed: #{Exception.message(e)}"}
    end
  end
  def to_list(map) do
    {:error, "Maps.to_list requires a map as argument, got #{inspect(map)}"}
  end

  @doc """
  Creates a map from a list of key-value tuples.
  Takes a list where each element is a two-element tuple {key, value}.
  
  ## Examples
      iex> Maps.from_list([{:a, 1}, {:b, 2}])
      {:ok, %{a: 1, b: 2}}
      
      iex> Maps.from_list([])
      {:ok, %{}}
  """
  def from_list(list) when is_list(list) do
    try do
      # Validate that all elements are 2-tuples with atom keys
      valid_tuples = Enum.all?(list, fn
        {key, _value} when is_atom(key) -> true
        _ -> false
      end)
      
      if valid_tuples do
        result = Map.new(list)
        {:ok, result}
      else
        {:error, "Maps.from_list requires a list of tuples with atom keys, got invalid format in #{inspect(list)}"}
      end
    rescue
      e -> {:error, "Maps.from_list failed: #{Exception.message(e)}"}
    end
  end
  def from_list(list) do
    {:error, "Maps.from_list requires a list as argument, got #{inspect(list)}"}
  end
end