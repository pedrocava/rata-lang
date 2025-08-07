defmodule MapsTest do
  use ExUnit.Case
  doctest RataModules.Maps

  alias RataModules.Maps

  describe "Maps.get/2" do
    test "returns value for existing atom key" do
      map = %{key: "value", number: 42}
      assert Maps.get(map, :key) == {:ok, "value"}
      assert Maps.get(map, :number) == {:ok, 42}
    end

    test "returns value for existing string key" do
      map = %{"key" => "value", "number" => 42}
      assert Maps.get(map, "key") == {:ok, "value"}
      assert Maps.get(map, "number") == {:ok, 42}
    end

    test "unified key access - atom and string keys are equivalent" do
      # Store with atom, access with string
      atom_map = %{key: "atom_stored"}
      assert Maps.get(atom_map, "key") == {:ok, "atom_stored"}
      
      # Store with string, access with atom
      string_map = %{"key" => "string_stored"}
      assert Maps.get(string_map, :key) == {:ok, "string_stored"}
    end

    test "returns nil for non-existing key" do
      map = %{key: "value"}
      assert Maps.get(map, :missing) == {:ok, nil}
      assert Maps.get(map, "missing") == {:ok, nil}
    end

    test "works with empty map" do
      map = %{}
      assert Maps.get(map, :any) == {:ok, nil}
      assert Maps.get(map, "any") == {:ok, nil}
    end

    test "returns error for non-map input" do
      assert Maps.get("not a map", :key) == {:error, "Maps.get requires a map as first argument, got \"not a map\""}
      assert Maps.get(123, :key) == {:error, "Maps.get requires a map as first argument, got 123"}
    end

    test "returns error for invalid key type" do
      map = %{key: "value"}
      assert Maps.get(map, 123) == {:error, "Maps.get requires an atom or string key as second argument, got 123"}
      assert Maps.get(map, []) == {:error, "Maps.get requires an atom or string key as second argument, got []"}
    end
  end

  describe "Maps.put/3" do
    test "adds new key-value pair to map" do
      map = %{existing: "value"}
      assert Maps.put(map, :new_key, "new_value") == {:ok, %{existing: "value", new_key: "new_value"}}
    end

    test "updates existing key in map" do
      map = %{key: "old_value"}
      assert Maps.put(map, :key, "new_value") == {:ok, %{key: "new_value"}}
    end

    test "unified key storage - normalizes to atoms and removes variants" do
      # Start with atom key, update with string key
      map = %{key: "atom_value"}
      {:ok, result} = Maps.put(map, "key", "string_update")
      assert result == %{key: "string_update"}
      
      # Start with string key, update with atom key
      map = %{"key" => "string_value"}
      {:ok, result} = Maps.put(map, :key, "atom_update")
      assert result == %{key: "atom_update"}
      
      # Should not have both string and atom versions
      refute Map.has_key?(result, "key")
    end

    test "works with empty map" do
      map = %{}
      assert Maps.put(map, :key, "value") == {:ok, %{key: "value"}}
      assert Maps.put(map, "key", "value") == {:ok, %{key: "value"}}
    end

    test "handles various value types" do
      map = %{}
      assert Maps.put(map, :string, "text") == {:ok, %{string: "text"}}
      assert Maps.put(map, "number", 42) == {:ok, %{number: 42}}
      assert Maps.put(map, :boolean, true) == {:ok, %{boolean: true}}
      assert Maps.put(map, "list", [1, 2, 3]) == {:ok, %{list: [1, 2, 3]}}
    end

    test "returns error for non-map input" do
      assert Maps.put("not a map", :key, "value") == {:error, "Maps.put requires a map as first argument, got \"not a map\""}
    end

    test "returns error for invalid key type" do
      map = %{}
      assert Maps.put(map, 123, "value") == {:error, "Maps.put requires an atom or string key as second argument, got 123"}
    end
  end

  describe "Maps.delete/2" do
    test "removes existing atom key from map" do
      map = %{keep: "this", remove: "this"}
      assert Maps.delete(map, :remove) == {:ok, %{keep: "this"}}
    end

    test "removes existing string key from map" do
      map = %{"keep" => "this", "remove" => "this"}
      assert Maps.delete(map, "remove") == {:ok, %{"keep" => "this"}}
    end

    test "unified key deletion - removes both string and atom variants" do
      # Delete atom key from string-keyed map
      string_map = %{"key" => "value", "other" => "keep"}
      assert Maps.delete(string_map, :key) == {:ok, %{"other" => "keep"}}
      
      # Delete string key from atom-keyed map
      atom_map = %{key: "value", other: "keep"}
      assert Maps.delete(atom_map, "key") == {:ok, %{other: "keep"}}
      
      # Map with both atom and string versions (edge case)
      mixed_map = %{key: "atom_value", "key" => "string_value", other: "keep"}
      {:ok, result} = Maps.delete(mixed_map, :key)
      assert result == %{other: "keep"}
      refute Map.has_key?(result, :key)
      refute Map.has_key?(result, "key")
    end

    test "returns original map when key doesn't exist" do
      map = %{key: "value"}
      assert Maps.delete(map, :missing) == {:ok, %{key: "value"}}
      assert Maps.delete(map, "missing") == {:ok, %{key: "value"}}
    end

    test "works with empty map" do
      map = %{}
      assert Maps.delete(map, :any) == {:ok, %{}}
      assert Maps.delete(map, "any") == {:ok, %{}}
    end

    test "returns error for non-map input" do
      assert Maps.delete("not a map", :key) == {:error, "Maps.delete requires a map as first argument, got \"not a map\""}
    end

    test "returns error for invalid key type" do
      map = %{key: "value"}
      assert Maps.delete(map, 123) == {:error, "Maps.delete requires an atom or string key as second argument, got 123"}
    end
  end

  describe "Maps.has_key/2" do
    test "returns true for existing atom key" do
      map = %{existing: "value", another: 42}
      assert Maps.has_key(map, :existing) == {:ok, true}
      assert Maps.has_key(map, :another) == {:ok, true}
    end

    test "returns true for existing string key" do
      map = %{"existing" => "value", "another" => 42}
      assert Maps.has_key(map, "existing") == {:ok, true}
      assert Maps.has_key(map, "another") == {:ok, true}
    end

    test "unified key detection - atom and string keys are equivalent" do
      # Store with atom, check with string
      atom_map = %{key: "value"}
      assert Maps.has_key(atom_map, "key") == {:ok, true}
      
      # Store with string, check with atom
      string_map = %{"key" => "value"}
      assert Maps.has_key(string_map, :key) == {:ok, true}
    end

    test "returns false for non-existing key" do
      map = %{key: "value"}
      assert Maps.has_key(map, :missing) == {:ok, false}
      assert Maps.has_key(map, "missing") == {:ok, false}
    end

    test "returns false for empty map" do
      map = %{}
      assert Maps.has_key(map, :any) == {:ok, false}
      assert Maps.has_key(map, "any") == {:ok, false}
    end

    test "returns error for non-map input" do
      assert Maps.has_key("not a map", :key) == {:error, "Maps.has_key requires a map as first argument, got \"not a map\""}
    end

    test "returns error for invalid key type" do
      map = %{key: "value"}
      assert Maps.has_key(map, 123) == {:error, "Maps.has_key requires an atom or string key as second argument, got 123"}
    end
  end

  describe "Maps.keys/1" do
    test "returns list of keys from map" do
      map = %{a: 1, b: 2, c: 3}
      {:ok, keys} = Maps.keys(map)
      assert Enum.sort(keys) == [:a, :b, :c]
    end

    test "returns empty list for empty map" do
      map = %{}
      assert Maps.keys(map) == {:ok, []}
    end

    test "works with single key map" do
      map = %{only: "key"}
      assert Maps.keys(map) == {:ok, [:only]}
    end

    test "returns error for non-map input" do
      assert Maps.keys("not a map") == {:error, "Maps.keys requires a map as argument, got \"not a map\""}
      assert Maps.keys(123) == {:error, "Maps.keys requires a map as argument, got 123"}
    end
  end

  describe "Maps.values/1" do
    test "returns list of values from map" do
      map = %{a: 1, b: 2, c: 3}
      {:ok, values} = Maps.values(map)
      assert Enum.sort(values) == [1, 2, 3]
    end

    test "returns empty list for empty map" do
      map = %{}
      assert Maps.values(map) == {:ok, []}
    end

    test "works with single value map" do
      map = %{key: "only value"}
      assert Maps.values(map) == {:ok, ["only value"]}
    end

    test "handles duplicate values" do
      map = %{a: "same", b: "same", c: "different"}
      {:ok, values} = Maps.values(map)
      assert Enum.sort(values) == ["different", "same", "same"]
    end

    test "returns error for non-map input" do
      assert Maps.values("not a map") == {:error, "Maps.values requires a map as argument, got \"not a map\""}
    end
  end

  describe "Maps.merge/2" do
    test "merges two maps with no overlapping keys" do
      map1 = %{a: 1, b: 2}
      map2 = %{c: 3, d: 4}
      assert Maps.merge(map1, map2) == {:ok, %{a: 1, b: 2, c: 3, d: 4}}
    end

    test "second map values overwrite first map values for duplicate keys" do
      map1 = %{a: 1, b: 2, c: 3}
      map2 = %{b: "new", c: "newer", d: 4}
      assert Maps.merge(map1, map2) == {:ok, %{a: 1, b: "new", c: "newer", d: 4}}
    end

    test "merges with empty maps" do
      map = %{key: "value"}
      empty = %{}
      assert Maps.merge(map, empty) == {:ok, %{key: "value"}}
      assert Maps.merge(empty, map) == {:ok, %{key: "value"}}
      assert Maps.merge(empty, empty) == {:ok, %{}}
    end

    test "returns error for non-map inputs" do
      map = %{key: "value"}
      assert Maps.merge("not a map", map) == {:error, "Maps.merge requires maps as arguments, got \"not a map\" as first argument"}
      assert Maps.merge(map, "not a map") == {:error, "Maps.merge requires maps as arguments, got \"not a map\" as second argument"}
    end
  end

  describe "Maps.size/1" do
    test "returns size of map" do
      assert Maps.size(%{}) == {:ok, 0}
      assert Maps.size(%{a: 1}) == {:ok, 1}
      assert Maps.size(%{a: 1, b: 2, c: 3}) == {:ok, 3}
    end

    test "returns error for non-map input" do
      assert Maps.size("not a map") == {:error, "Maps.size requires a map as argument, got \"not a map\""}
      assert Maps.size([1, 2, 3]) == {:error, "Maps.size requires a map as argument, got [1, 2, 3]"}
    end
  end

  describe "Maps.empty/1" do
    test "returns true for empty map" do
      assert Maps.empty(%{}) == {:ok, true}
    end

    test "returns false for non-empty map" do
      assert Maps.empty(%{key: "value"}) == {:ok, false}
      assert Maps.empty(%{a: 1, b: 2}) == {:ok, false}
    end

    test "returns error for non-map input" do
      assert Maps.empty("not a map") == {:error, "Maps.empty requires a map as argument, got \"not a map\""}
      assert Maps.empty([]) == {:error, "Maps.empty requires a map as argument, got []"}
    end
  end

  describe "Maps.to_list/1" do
    test "converts map to list of key-value lists" do
      map = %{a: 1, b: 2}
      {:ok, list} = Maps.to_list(map)
      assert Enum.sort(list) == [{:a, 1}, {:b, 2}]
    end

    test "returns empty list for empty map" do
      assert Maps.to_list(%{}) == {:ok, []}
    end

    test "works with single entry map" do
      map = %{only: "entry"}
      assert Maps.to_list(map) == {:ok, [{:only, "entry"}]}
    end

    test "handles various value types" do
      map = %{string: "text", number: 42, list: [1, 2, 3]}
      {:ok, list} = Maps.to_list(map)
      assert length(list) == 3
      assert Enum.member?(list, {:string, "text"})
      assert Enum.member?(list, {:number, 42})
      assert Enum.member?(list, {:list, [1, 2, 3]})
    end

    test "returns error for non-map input" do
      assert Maps.to_list("not a map") == {:error, "Maps.to_list requires a map as argument, got \"not a map\""}
    end
  end

  describe "Maps.from_list/1" do
    test "creates map from list of key-value lists" do
      list = [{:a, 1}, {:b, 2}, {:c, 3}]
      assert Maps.from_list(list) == {:ok, %{a: 1, b: 2, c: 3}}
    end

    test "creates empty map from empty list" do
      assert Maps.from_list([]) == {:ok, %{}}
    end

    test "creates single entry map from single list list" do
      list = [{:only, "entry"}]
      assert Maps.from_list(list) == {:ok, %{only: "entry"}}
    end

    test "handles various value types" do
      list = [{:string, "text"}, {:number, 42}, {:boolean, true}, {:list, [1, 2, 3]}]
      expected = %{string: "text", number: 42, boolean: true, list: [1, 2, 3]}
      assert Maps.from_list(list) == {:ok, expected}
    end

    test "later entries overwrite earlier entries for duplicate keys" do
      list = [{:key, "first"}, {:key, "second"}, {:other, "value"}]
      assert Maps.from_list(list) == {:ok, %{key: "second", other: "value"}}
    end

    test "returns error for non-list input" do
      assert Maps.from_list("not a list") == {:error, "Maps.from_list requires a list as argument, got \"not a list\""}
      assert Maps.from_list(%{key: "value"}) == {:error, "Maps.from_list requires a list as argument, got %{key: \"value\"}"}
    end

    test "accepts both atom and string keys in lists" do
      # Mixed atom and string keys
      list = [{:atom_key, "atom_value"}, {"string_key", "string_value"}]
      expected = %{atom_key: "atom_value", string_key: "string_value"}
      assert Maps.from_list(list) == {:ok, expected}
    end

    test "returns error for invalid list format" do
      # Non-list elements
      list = [{:valid, "list"}, "invalid element"]
      assert Maps.from_list(list) == {:error, "Maps.from_list requires a list of lists with atom or string keys, got invalid format in [{:valid, \"list\"}, \"invalid element\"]"}
      
      # Tuple with invalid key type
      list = [{123, "value"}]
      assert Maps.from_list(list) == {:error, "Maps.from_list requires a list of lists with atom or string keys, got invalid format in [{123, \"value\"}]"}
      
      # Tuples with wrong arity
      list = [{:key}]
      assert Maps.from_list(list) == {:error, "Maps.from_list requires a list of lists with atom or string keys, got invalid format in [key: {}]"}
    end
  end
end