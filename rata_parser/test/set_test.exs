defmodule SetTest do
  use ExUnit.Case
  alias RataModules.Set

  describe "Set.new/1" do
    test "creates a new set from a list" do
      assert {:ok, set} = Set.new([1, 2, 3])
      assert MapSet.equal?(set, MapSet.new([1, 2, 3]))
    end

    test "creates a set removing duplicates" do
      assert {:ok, set} = Set.new([1, 2, 2, 3, 1])
      assert MapSet.equal?(set, MapSet.new([1, 2, 3]))
    end

    test "creates an empty set from empty list" do
      assert {:ok, set} = Set.new([])
      assert MapSet.equal?(set, MapSet.new())
    end

    test "returns error for non-list input" do
      assert {:error, "Set.new/1 requires a vector (list) of elements"} = Set.new("not a list")
      assert {:error, "Set.new/1 requires a vector (list) of elements"} = Set.new(123)
      assert {:error, "Set.new/1 requires a vector (list) of elements"} = Set.new(%{})
    end
  end

  describe "Set.add/2" do
    test "adds element to existing set" do
      {:ok, original} = Set.new([1, 2])
      assert {:ok, new_set} = Set.add(original, 3)
      assert MapSet.equal?(new_set, MapSet.new([1, 2, 3]))
    end

    test "adding existing element doesn't change set" do
      {:ok, original} = Set.new([1, 2, 3])
      assert {:ok, new_set} = Set.add(original, 2)
      assert MapSet.equal?(new_set, original)
    end

    test "returns error for non-set input" do
      assert {:error, "Set.add/2 requires a set as first argument"} = Set.add([1, 2], 3)
      assert {:error, "Set.add/2 requires a set as first argument"} = Set.add("not a set", 3)
    end
  end

  describe "Set.delete/2" do
    test "removes element from set" do
      {:ok, original} = Set.new([1, 2, 3])
      assert {:ok, new_set} = Set.delete(original, 2)
      assert MapSet.equal?(new_set, MapSet.new([1, 3]))
    end

    test "removing non-existent element doesn't change set" do
      {:ok, original} = Set.new([1, 2, 3])
      assert {:ok, new_set} = Set.delete(original, 4)
      assert MapSet.equal?(new_set, original)
    end

    test "returns error for non-set input" do
      assert {:error, "Set.delete/2 requires a set as first argument"} = Set.delete([1, 2], 3)
      assert {:error, "Set.delete/2 requires a set as first argument"} = Set.delete("not a set", 3)
    end
  end

  describe "Set.member?/2" do
    test "returns true for existing element" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:ok, true} = Set.member?(set, 2)
    end

    test "returns false for non-existing element" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:ok, false} = Set.member?(set, 4)
    end

    test "works with empty set" do
      {:ok, set} = Set.new([])
      assert {:ok, false} = Set.member?(set, 1)
    end

    test "returns error for non-set input" do
      assert {:error, "Set.member?/2 requires a set as first argument"} = Set.member?([1, 2], 3)
      assert {:error, "Set.member?/2 requires a set as first argument"} = Set.member?("not a set", 3)
    end
  end

  describe "Set.size/1" do
    test "returns correct size for non-empty set" do
      {:ok, set} = Set.new([1, 2, 3, 4])
      assert {:ok, 4} = Set.size(set)
    end

    test "returns zero for empty set" do
      {:ok, set} = Set.new([])
      assert {:ok, 0} = Set.size(set)
    end

    test "handles duplicates correctly" do
      {:ok, set} = Set.new([1, 1, 2, 2, 3])
      assert {:ok, 3} = Set.size(set)
    end

    test "returns error for non-set input" do
      assert {:error, "Set.size/1 requires a set as argument"} = Set.size([1, 2, 3])
      assert {:error, "Set.size/1 requires a set as argument"} = Set.size("not a set")
    end
  end

  describe "Set.union/2" do
    test "creates union of two sets" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([3, 4, 5])
      assert {:ok, result} = Set.union(set1, set2)
      assert MapSet.equal?(result, MapSet.new([1, 2, 3, 4, 5]))
    end

    test "union with empty set returns original set" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([])
      assert {:ok, result} = Set.union(set1, set2)
      assert MapSet.equal?(result, set1)
    end

    test "union of identical sets returns same set" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([1, 2, 3])
      assert {:ok, result} = Set.union(set1, set2)
      assert MapSet.equal?(result, set1)
    end

    test "returns error for non-set inputs" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:error, "Set.union/2 requires two sets as arguments"} = Set.union(set, [1, 2])
      assert {:error, "Set.union/2 requires two sets as arguments"} = Set.union([1, 2], set)
      assert {:error, "Set.union/2 requires two sets as arguments"} = Set.union("not", "sets")
    end
  end

  describe "Set.intersection/2" do
    test "creates intersection of two sets" do
      {:ok, set1} = Set.new([1, 2, 3, 4])
      {:ok, set2} = Set.new([3, 4, 5, 6])
      assert {:ok, result} = Set.intersection(set1, set2)
      assert MapSet.equal?(result, MapSet.new([3, 4]))
    end

    test "intersection with empty set returns empty set" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([])
      assert {:ok, result} = Set.intersection(set1, set2)
      assert MapSet.equal?(result, MapSet.new())
    end

    test "intersection of disjoint sets returns empty set" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([4, 5, 6])
      assert {:ok, result} = Set.intersection(set1, set2)
      assert MapSet.equal?(result, MapSet.new())
    end

    test "returns error for non-set inputs" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:error, "Set.intersection/2 requires two sets as arguments"} = Set.intersection(set, [1, 2])
      assert {:error, "Set.intersection/2 requires two sets as arguments"} = Set.intersection([1, 2], set)
    end
  end

  describe "Set.difference/2" do
    test "creates difference of two sets" do
      {:ok, set1} = Set.new([1, 2, 3, 4])
      {:ok, set2} = Set.new([3, 4, 5, 6])
      assert {:ok, result} = Set.difference(set1, set2)
      assert MapSet.equal?(result, MapSet.new([1, 2]))
    end

    test "difference with empty set returns original set" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([])
      assert {:ok, result} = Set.difference(set1, set2)
      assert MapSet.equal?(result, set1)
    end

    test "difference of identical sets returns empty set" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([1, 2, 3])
      assert {:ok, result} = Set.difference(set1, set2)
      assert MapSet.equal?(result, MapSet.new())
    end

    test "returns error for non-set inputs" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:error, "Set.difference/2 requires two sets as arguments"} = Set.difference(set, [1, 2])
      assert {:error, "Set.difference/2 requires two sets as arguments"} = Set.difference([1, 2], set)
    end
  end

  describe "Set.symmetric_difference/2" do
    test "creates symmetric difference of two sets" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([3, 4, 5])
      assert {:ok, result} = Set.symmetric_difference(set1, set2)
      assert MapSet.equal?(result, MapSet.new([1, 2, 4, 5]))
    end

    test "symmetric difference with empty set returns original set" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([])
      assert {:ok, result} = Set.symmetric_difference(set1, set2)
      assert MapSet.equal?(result, set1)
    end

    test "symmetric difference of identical sets returns empty set" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([1, 2, 3])
      assert {:ok, result} = Set.symmetric_difference(set1, set2)
      assert MapSet.equal?(result, MapSet.new())
    end

    test "returns error for non-set inputs" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:error, "Set.symmetric_difference/2 requires two sets as arguments"} = Set.symmetric_difference(set, [1, 2])
      assert {:error, "Set.symmetric_difference/2 requires two sets as arguments"} = Set.symmetric_difference([1, 2], set)
    end
  end

  describe "Set.subset?/2" do
    test "returns true when first set is subset of second" do
      {:ok, set1} = Set.new([1, 2])
      {:ok, set2} = Set.new([1, 2, 3, 4])
      assert {:ok, true} = Set.subset?(set1, set2)
    end

    test "returns true when sets are equal" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([1, 2, 3])
      assert {:ok, true} = Set.subset?(set1, set2)
    end

    test "returns false when first set is not subset" do
      {:ok, set1} = Set.new([1, 2, 5])
      {:ok, set2} = Set.new([1, 2, 3, 4])
      assert {:ok, false} = Set.subset?(set1, set2)
    end

    test "empty set is subset of any set" do
      {:ok, set1} = Set.new([])
      {:ok, set2} = Set.new([1, 2, 3])
      assert {:ok, true} = Set.subset?(set1, set2)
    end

    test "returns error for non-set inputs" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:error, "Set.subset?/2 requires two sets as arguments"} = Set.subset?(set, [1, 2])
      assert {:error, "Set.subset?/2 requires two sets as arguments"} = Set.subset?([1, 2], set)
    end
  end

  describe "Set.disjoint?/2" do
    test "returns true when sets have no common elements" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([4, 5, 6])
      assert {:ok, true} = Set.disjoint?(set1, set2)
    end

    test "returns false when sets have common elements" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([3, 4, 5])
      assert {:ok, false} = Set.disjoint?(set1, set2)
    end

    test "empty sets are disjoint" do
      {:ok, set1} = Set.new([])
      {:ok, set2} = Set.new([])
      assert {:ok, true} = Set.disjoint?(set1, set2)
    end

    test "empty set is disjoint from any set" do
      {:ok, set1} = Set.new([])
      {:ok, set2} = Set.new([1, 2, 3])
      assert {:ok, true} = Set.disjoint?(set1, set2)
    end

    test "returns error for non-set inputs" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:error, "Set.disjoint?/2 requires two sets as arguments"} = Set.disjoint?(set, [1, 2])
      assert {:error, "Set.disjoint?/2 requires two sets as arguments"} = Set.disjoint?([1, 2], set)
    end
  end

  describe "Set.equal?/2" do
    test "returns true for identical sets" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([3, 2, 1])  # Order doesn't matter
      assert {:ok, true} = Set.equal?(set1, set2)
    end

    test "returns false for different sets" do
      {:ok, set1} = Set.new([1, 2, 3])
      {:ok, set2} = Set.new([1, 2, 4])
      assert {:ok, false} = Set.equal?(set1, set2)
    end

    test "returns true for empty sets" do
      {:ok, set1} = Set.new([])
      {:ok, set2} = Set.new([])
      assert {:ok, true} = Set.equal?(set1, set2)
    end

    test "returns error for non-set inputs" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:error, "Set.equal?/2 requires two sets as arguments"} = Set.equal?(set, [1, 2])
      assert {:error, "Set.equal?/2 requires two sets as arguments"} = Set.equal?([1, 2], set)
    end
  end

  describe "Set.empty?/1" do
    test "returns true for empty set" do
      {:ok, set} = Set.new([])
      assert {:ok, true} = Set.empty?(set)
    end

    test "returns false for non-empty set" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:ok, false} = Set.empty?(set)
    end

    test "returns error for non-set input" do
      assert {:error, "Set.empty?/1 requires a set as argument"} = Set.empty?([])
      assert {:error, "Set.empty?/1 requires a set as argument"} = Set.empty?("not a set")
    end
  end

  describe "Set.to_vector/1" do
    test "converts set to list" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:ok, list} = Set.to_vector(set)
      # Order may vary, so check that all elements are present
      assert length(list) == 3
      assert Enum.all?([1, 2, 3], fn x -> x in list end)
    end

    test "converts empty set to empty list" do
      {:ok, set} = Set.new([])
      assert {:ok, []} = Set.to_vector(set)
    end

    test "returns error for non-set input" do
      assert {:error, "Set.to_vector/1 requires a set as argument"} = Set.to_vector([1, 2, 3])
      assert {:error, "Set.to_vector/1 requires a set as argument"} = Set.to_vector("not a set")
    end
  end

  describe "Set.from_vector/1" do
    test "creates set from list" do
      assert {:ok, set} = Set.from_vector([1, 2, 3, 2])
      assert MapSet.equal?(set, MapSet.new([1, 2, 3]))
    end

    test "creates empty set from empty list" do
      assert {:ok, set} = Set.from_vector([])
      assert MapSet.equal?(set, MapSet.new())
    end

    test "returns error for non-list input" do
      assert {:error, "Set.from_vector/1 requires a vector (list) of elements"} = Set.from_vector("not a list")
      assert {:error, "Set.from_vector/1 requires a vector (list) of elements"} = Set.from_vector(123)
    end
  end

  describe "Set.first/1" do
    test "returns an element from non-empty set" do
      {:ok, set} = Set.new([42])
      assert {:ok, 42} = Set.first(set)
    end

    test "returns an element from multi-element set" do
      {:ok, set} = Set.new([1, 2, 3])
      assert {:ok, element} = Set.first(set)
      assert element in [1, 2, 3]
    end

    test "returns error for empty set" do
      {:ok, set} = Set.new([])
      assert {:error, "Set is empty"} = Set.first(set)
    end

    test "returns error for non-set input" do
      assert {:error, "Set.first/1 requires a set as argument"} = Set.first([1, 2, 3])
      assert {:error, "Set.first/1 requires a set as argument"} = Set.first("not a set")
    end
  end
end